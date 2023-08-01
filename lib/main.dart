import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:calendar/database/note_database.dart';
import 'package:calendar/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Helper/theme.dart';
import 'Helper/theme_service.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeService().theme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset(
            "assets/images/logo.webp",
            width: 40,
            height: 50,
          ),
          const Text(
            "NoteApp",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
      nextScreen: const IndexScreen(),
      backgroundColor: Colors.black,
      duration: 4000,
      splashIconSize: 250,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 2),
    );
  }
}

class IndexScreen extends StatelessWidget {
  const IndexScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NoteDatabase>(
      future: $FloorNoteDatabase.databaseBuilder('note.db').build(),
      builder: (context, data) {
        if (data.hasData) {
          Get.put(data.data!.noteDao);
          return Home(data.data!.noteDao);
        } else if (data.hasError) {
          return const Center(child: Text('Error'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }  
      },
    );
  }
}
