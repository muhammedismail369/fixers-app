import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final FirebaseAuth _firebaseAuth;

  AuthBloc({
    required AuthService authService,
    required FirebaseAuth firebaseAuth,
  })  : _authService = authService,
        _firebaseAuth = firebaseAuth,
        super(AuthInitial()) {
    // Check current auth state
    on<AuthCheckRequested>((event, emit) {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    // Handle sign in
    on<AuthEmailSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _authService.signInWithEmail(
          email: event.email,
          password: event.password,
        );

        if (userCredential?.user != null) {
          emit(Authenticated(userCredential!.user!));
        } else {
          emit(const AuthError('Authentication failed'));
        }
      } catch (e) {
        emit(AuthError(_getReadableErrorMessage(e.toString())));
      }
    });

    // Handle sign up
    on<AuthEmailSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _authService.signUpWithEmail(
          email: event.email,
          password: event.password,
          name: event.name,
        );

        if (userCredential?.user != null) {
          emit(Authenticated(userCredential!.user!));
        } else {
          emit(const AuthError('Registration failed'));
        }
      } catch (e) {
        emit(AuthError(_getReadableErrorMessage(e.toString())));
      }
    });

    // Handle sign out
    on<AuthSignOutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authService.signOut();
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthError(_getReadableErrorMessage(e.toString())));
      }
    });
  }

  String _getReadableErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No account found with this email. Please check your email or sign up.';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password. Please check your password and try again.';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email format. Please enter a valid email address.';
    } else if (error.contains('email-already-in-use')) {
      return 'This email is already registered. Please try logging in instead.';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak. Please use a stronger password with letters and numbers.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your internet connection and try again.';
    } else if (error.contains('too-many-requests')) {
      return 'Too many failed attempts. Please wait a few minutes before trying again.';
    } else {
      return 'Authentication failed. Please check your credentials and try again.';
    }
  }
}
