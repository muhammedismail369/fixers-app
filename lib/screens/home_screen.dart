import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'auth_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return IconButton(
                  icon: state is AuthLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.logout),
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(AuthSignOutRequested());
                        },
                );
              },
            ),
          ],
        ),
        body: const Center(
          child: Text('Welcome to Fixers App!'),
        ),
      ),
    );
  }
}
