import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/data/firebase_auth_repo.dart';
import 'features/auth/presentation/cubits/auth_cubits.dart';
import 'features/auth/presentation/cubits/auth_states.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_pages.dart';
import 'features/posts/data/firebase_post_repo.dart';
import 'features/posts/presentation/cubits/post_cubit.dart';
import 'features/profile/data/firebase_profile_repo.dart';
import 'features/profile/presentation/cubits/profile_cubit.dart';
import 'features/search/data/firebase_search_repo.dart';
import 'features/search/presentation/cubits/search_cubit.dart';
import 'features/storage/data/firebase_storage_repo.dart';
import 'theme/theme_cubit.dart';

/*

Repositories: for the database
  - firebase

Bloc Providers: for state management
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State
  - unauthenticated -> auth page (login/register)
  - authenticated -> home page

*/

class MyApp extends StatelessWidget {
  // auth Repo
  final FirebaseAuthRepo authRepo = FirebaseAuthRepo();

  //profile Repo
  final FirebaseProfileRepo profileRepo = FirebaseProfileRepo();
  final FirebaseStorageRepo firebaseStorageRepo = FirebaseStorageRepo();
  final FirebasePostRepo firebasePostRepo = FirebasePostRepo();
  final FirebaseSearchRepo firebaseSearchRepo = FirebaseSearchRepo();
  final SharedPreferences sharedPreferences;

  MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
        ),

        // profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: profileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),

        BlocProvider(
            create: (context) => PostCubit(
                postRepo: firebasePostRepo, storageRepo: firebaseStorageRepo)),

        // search cubit
        BlocProvider(
            create: (context) => SearchCubit(searchRepo: firebaseSearchRepo)),

        // theme cubit
        BlocProvider(
            create: (context) => ThemeCubit(sharedPreferences,
                sharedPreferences.getBool('isDarkMode') ?? false)),
      ],
      // Check Theme
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state,

          // Check Auth
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, authState) {
              // unauthenticated -> auth page (login/register)
              if (authState is Unauthenticated) {
                return AuthPage(
                  showLoginPage: authState.showLoginPage,
                );
              }

              // authenticated -> homepage
              else if (authState is Authenticated) {
                return const HomePage();
              }

              // loading
              else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },

            // listen for errors....
            listener: (context, authState) {
              if (authState is AuthError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(authState.message)));
              }
            },
          ),
        ),
      ),
    );
  }
}
