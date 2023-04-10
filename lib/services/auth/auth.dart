import 'package:flutter/foundation.dart' show immutable;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart';

const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'invalid-password': AuthErrorWrongPassword(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthOperationNotAllowed(),
  'weak-password': AuthErrorWeakPassword(),
  'requires-recent-login': AuthErrorRequiresRecentlogin(),
  'network-request-failed': AuthErrorNetworkRequestFailed(),
  'too-many-requests': AuthErrorTooManyRequests(),
  'user-disabled': AuthErrorUserDisabled(),
  'session-expired': AuthErrorSessionExpired(),
  'no-current-user': AuthErrorNoCurrentUser(),
  'unknown': AuthErrorUnknown(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogContent;

  const AuthError({
    required this.dialogTitle,
    required this.dialogContent,
  });

  factory AuthError.from(FirebaseAuthException exception) {
    return authErrorMapping[exception.code.toLowerCase().trim()] ??
        const AuthErrorUnknown();
  }
}

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogTitle: "Unknown Error",
          dialogContent:
              "An unknown error has occurred. Please try again later.",
        );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: "No Current User",
          dialogContent: "No current user is logged in.",
        );
}

@immutable
class AuthErrorRequiresRecentlogin extends AuthError {
  const AuthErrorRequiresRecentlogin()
      : super(
          dialogTitle: "Requires Recent Login",
          dialogContent:
              "This operation requires recent authentication. Log in again before retrying this request.",
        );
}

@immutable
class AuthOperationNotAllowed extends AuthError {
  const AuthOperationNotAllowed()
      : super(
          dialogTitle: "Operation Not Allowed",
          dialogContent:
              "You cannot register using this method at this time. Please try again later.",
        );
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: "Email Already In Use",
          dialogContent:
              "The email address is already in use by another account.",
        );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: "Invalid Email",
          dialogContent: "The email address is badly formatted.",
        );
}

@immutable
class AuthErrorWrongPassword extends AuthError {
  const AuthErrorWrongPassword()
      : super(
          dialogTitle: "Wrong Password",
          dialogContent:
              "The password is invalid or the user does not have a password.",
        );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: "User Not Found",
          dialogContent:
              "There is no user record corresponding to this identifier. The user may have been deleted.",
        );
}

@immutable
class AuthErrorTooManyRequests extends AuthError {
  const AuthErrorTooManyRequests()
      : super(
          dialogTitle: "Too Many Requests",
          dialogContent:
              "We have blocked all requests from this device due to unusual activity. Try again later.",
        );
}

@immutable
class AuthErrorUserDisabled extends AuthError {
  const AuthErrorUserDisabled()
      : super(
          dialogTitle: "User Disabled",
          dialogContent:
              "The user account has been disabled by an administrator.",
        );
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogTitle: "Weak Password",
          dialogContent: "The password must be 6 characters long or more.",
        );
}

@immutable
class AuthErrorNetworkRequestFailed extends AuthError {
  const AuthErrorNetworkRequestFailed()
      : super(
          dialogTitle: "Network Request Failed",
          dialogContent:
              "A network error (such as timeout, interrupted connection or unreachable host) has occurred.",
        );
}

@immutable
class AuthErrorSessionExpired extends AuthError {
  const AuthErrorSessionExpired()
      : super(
          dialogTitle: "Session Expired",
          dialogContent:
              "The SMS code has expired. Please re-send the verification code to try again.",
        );
}
