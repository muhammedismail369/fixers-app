import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthValidationError extends AuthState {
  final String message;
  final AuthValidationType type;

  const AuthValidationError({
    required this.message,
    required this.type,
  });

  @override
  List<Object> get props => [message, type];
}

enum AuthValidationType { email, password, name, confirmPassword, other }
