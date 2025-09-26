import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapinve/blocs/auth/auth_bloc.dart';
import 'package:lapinve/firebase_options.dart';
import 'package:lapinve/repositories/firebase_auth_repository.dart';
import 'package:lapinve/router/app_router.dart';
// import 'package:lapinve/screens/home_screen.dart';
import 'package:sizer/sizer.dart';
// import 'package:rive/rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await RiveFile.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(LapInve());
}

class LapInve extends StatelessWidget {
  const LapInve({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<FirebaseAuthRepository>(
              create: (context) => FirebaseAuthRepository(),
            ),
            // RepositoryProvider(create: (context) => SubjectRepository()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(
                  authRepository: context.read<FirebaseAuthRepository>(),
                )..add(AuthStatusRequested()),
              ),
              // BlocProvider(create: (context) => SubjectBloc()),
            ],
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(fontFamily: "DMSans"),
              routerConfig: router,
            ),
          ),
        );
      },
    );
  }
}
