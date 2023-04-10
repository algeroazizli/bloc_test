import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluter_bloc_app/services/auth/auth.dart';
import 'package:fluter_bloc_app/utils/upload_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventGoToRegister>((event, emit) {
      emit(
        const AppStateIsInRegisterView(
          isLoading: false,
        ),
      );
    });
    on<AppEventLogin>((event, emit) async {
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      // log user in
      try {
        final email = event.email;
        final password = event.password;
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user!;
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    on<AppEventGoToLogin>((event, emit)  {
      emit(
        const AppStateLoggedOut(isLoading: false),
      );
    });
    on<AppEventRegister>((event, emit) async {
      emit(
        const AppStateIsInRegisterView(
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        // create user
        final userCreds =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final userId = userCreds.user!.uid;
        // get user images
        emit(
          AppStateLoggedIn(
            user: userCreds.user!,
            images: const [],
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegisterView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    on<AppEventInitialize>((event, emit) async {
      // get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } else {
        // go grab user images
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ));
      }
    });

    on<AppEventLogOut>((event, emit) async {
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      await FirebaseAuth.instance.signOut();
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }
        emit(AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ));
        try {
          // delete user files
          final fodlerContents =
              await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in fodlerContents.items) {
            await item.delete().catchError((_) {});
          }
          // delete user folder
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});
          // delete user account
          await user.delete();
          await FirebaseAuth.instance.signOut();
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: false,
            authError: AuthError.from(e),
          ));
        } on FirebaseException {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        if (user == null) {
          // log user out if user is null
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );

        final file = File(event.imagePath);
        await uploadImage(
          file: file,
          userId: user.uid,
        );
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance.ref(userId).list().then(
            (listResult) => listResult.items,
          );
}
