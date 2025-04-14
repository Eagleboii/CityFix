import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/issue_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/issue_provider.dart';
import 'providers/auth_provider.dart';
import 'utils/app_localizations.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => IssueProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'CityFix',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getThemeData(),
            // Set up localization
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('fr', ''), // French
              Locale('es', ''), // Spanish
              Locale('de', ''), // German
              Locale('ar', ''), // Arabic
            ],
            // Let the system detect language automatically
            localeResolutionCallback: (locale, supportedLocales) {
              // If no locale is provided, use English
              if (locale == null) {
                return const Locale('en', '');
              }

              // Check if the device locale is supported
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              // If the locale of the device is not supported, use English
              return const Locale('en', '');
            },
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
