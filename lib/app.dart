import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth_page.dart';
import 'package:social_media_app/features/post/presentation/pages/home_page.dart';
import 'package:social_media_app/themes/light_mode.dart';

// ROOT LEVEL

// Repositories : for the database
// - firebase

// Bloc Providers : for state managment
// - auth
// - profile
// - post
// - search
// - theme

// Check auth state
// - unauthenticated -> auth page
//  authenticated -> home page

class MyApp extends StatelessWidget {
  // auth repo
  final authRepo = FirebaseAuthRepo();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // provide cubit to app
    return BlocProvider(
      create: (create) => AuthCubit(authRepo: authRepo)..checkAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(builder: (context, authState) {
          print(authState);
          if (authState is Unauthenticated) {
            return const AuthPage();
          }

          // auth
          if (authState is Authenticated) {
            return const HomePage();
          }

          // Loading
          else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },

            // listen for errors
            listener: (context, authState) {
          if (authState is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(authState.message)));
          }
        }),
      ),
    );
  }
}
