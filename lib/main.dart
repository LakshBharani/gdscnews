import 'package:flutter/material.dart';
import 'package:gdscnews/screens/home.dart';
import 'package:gdscnews/screens/news.details.dart';
import 'package:gdscnews/screens/user.profile.dart';

Future<void> main() async {
  // Ensuring that the Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Running the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/user-profile': (context) => const UserProfilePage(),
        '/news-details': (context) => const NewsDetailsPage(),
      },
    );
  }
}
