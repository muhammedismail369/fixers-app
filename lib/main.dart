import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'services/auth_service.dart';
import 'screens/spash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for Android only
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyB42T_z2cekcJI77CmW4juGcYJhbC9In80',
      appId: '1:718560605482:android:c17e326372fb25f040da53',
      messagingSenderId: '718560605482',
      projectId: 'fixers-app-767aa',
      storageBucket: 'fixers-app-767aa.firebasestorage.app',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authService: AuthService(),
            firebaseAuth: FirebaseAuth.instance,
          )..add(AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Fixers',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF6B00), // Orange color from the logo
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
