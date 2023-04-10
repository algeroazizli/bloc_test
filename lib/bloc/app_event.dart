import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventLogin implements AppEvent {
  final String email;
  final String password;

  const AppEventLogin({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventRegister implements AppEvent {
  final String email;
  final String password;

  const AppEventRegister({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventGoToLogin implements AppEvent {
  const AppEventGoToLogin();
}

@immutable
class AppEventGoToRegister implements AppEvent {
  const AppEventGoToRegister();
}

@immutable
class AppEventUploadImage implements AppEvent {
  final String imagePath;

  const AppEventUploadImage({
    required this.imagePath,
  });
}

@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogOut implements AppEvent {
  const AppEventLogOut();
}

@immutable
class AppEventInitialize implements AppEvent {
  const AppEventInitialize();
}
