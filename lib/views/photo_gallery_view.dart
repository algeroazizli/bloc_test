import 'package:fluter_bloc_app/bloc/app_bloc.dart';
import 'package:fluter_bloc_app/bloc/app_event.dart';
import 'package:fluter_bloc_app/bloc/app_state.dart';
import 'package:fluter_bloc_app/views/main_popup_menu_button.dart';
import 'package:fluter_bloc_app/views/store_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();
    final picker = useMemoized(
      () => ImagePicker(),
      [key],
    );
    final images = context.watch<AppBloc>().state.images ?? [];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () async {
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) {
                return;
              }
              appBloc.add(
                AppEventUploadImage(imagePath: image.path),
              );
            },
          ),
          const MainMenuPopUpButton()
        ],
        title: const Text('Photo Gallery'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: images
            .map(
              (img) => StoreimageView(image: img),
            )
            .toList(),
      ),
    );
  }
}
