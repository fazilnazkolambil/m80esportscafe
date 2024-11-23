import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:m80_esports/amplifyconfiguration.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/features/authPage/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/globalVariables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _configureAmplify() async {
    var authPlugin = AmplifyAuthCognito();
    // await Amplify.addPlugin(authPlugin);
    // await Amplify.configure(amplifyconfig);
    if (!mounted) return;
    authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugins([authPlugin, AmplifyAPI()]);
    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print('error : $e');
    }
  }

  @override
  void initState() {
    _configureAmplify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: ColorConst.backgroundColor.withOpacity(0.8),
          textTheme: GoogleFonts.orbitronTextTheme(),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
