import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isMinimumDurationPassed = false;

  @override
  void initState() {
    super.initState();
    _startMinimumDuration();
  }

  void _startMinimumDuration() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isMinimumDurationPassed = true;
        });
        _checkAuthAndNavigate();
      }
    });
  }

  void _checkAuthAndNavigate() {
    if (!_isMinimumDurationPassed) return;

    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (state is Unauthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _checkAuthAndNavigate();
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[50]!,
                Colors.white,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with fade-in animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 24),
                // App Name with fade-in animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  curve: Curves.easeIn,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: const Text(
                    'Fixers',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                // Loading Indicator with fade-in animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  curve: Curves.easeIn,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFFF6B00)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
