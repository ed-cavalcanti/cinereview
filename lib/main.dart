import 'package:cinereview/app.dart';
import 'package:cinereview/app/data/repositories/characters_repository.dart';
import 'package:cinereview/app/data/repositories/reviews_repository.dart';
import 'package:cinereview/app/data/repositories/users_repository.dart';
import 'package:cinereview/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => UsersRepository(
            auth: context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewsRepository(
            auth: context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CharactersRepository(
            auth: context.read<AuthService>(),
          ),
        )
      ],
      child: const App(),
    ),
  );
}
