import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:golden_ticket/src/golden_ticket/the_forge_screen.dart';
import 'package:provider/provider.dart';

import 'golden_ticket/auth/auth_state.dart'; // Import AuthState
import 'golden_ticket/main_screen.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'golden_ticket/sign_in_screen.dart';
import 'golden_ticket/game_selector_screen.dart';
import 'golden_ticket/smelter.dart';
import 'golden_ticket/verify_results_screen.dart';
import 'golden_ticket/create_account_screen.dart'; // Import CreateAccountScreen
import 'golden_ticket/routes.dart';
import 'golden_ticket/account_screen.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return ChangeNotifierProvider(
          // Provide AuthState to the entire app
          create: (context) => AuthState(),
          child: MaterialApp(
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case Routes.settings:
                      return SettingsView(controller: settingsController);
                    case Routes.signIn:
                      return const SignInScreen();
                    case Routes.gameSelector:
                      return const GameSelectorScreen();
                    case Routes.theForge:
                      return const TheForgeScreen();
                    case Routes.theSmelter:
                      return const TheSmelter();
                    case Routes.verifyResults:
                      return const VerifyResultsScreen();
                    case Routes.createAccount: // Add the new route
                      return const CreateAccountScreen();
                    case Routes.account:
                      return const AccountScreen();
                    case Routes.main:
                    default:
                      return const MainScreen();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
