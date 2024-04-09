import 'package:flutter/material.dart';
import 'package:gdscnews/screens/home/best.news.dart';
import 'package:gdscnews/screens/home/new.news.dart';
import 'package:gdscnews/screens/home/top.news.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> newNews = [];
  int newNewsLimit = 10;
  bool isLoading = false;

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hacker News App'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          shadowColor: Colors.deepPurple,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/bookmarks');
              },
              icon: const Icon(Icons.bookmark_rounded),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.deepPurple,
          currentIndex: currentPageIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.new_releases),
              label: 'New',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Best',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Top',
            ),
          ],
          onTap: (int index) {
            setState(() {
              isLoading = true;
            });
            switch (index) {
              case 0:
                currentPageIndex = 0;
                break;
              case 1:
                currentPageIndex = 1;
                break;
              case 2:
                currentPageIndex = 2;
                break;
            }
          },
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: IndexedStack(
            index: currentPageIndex,
            children: const [
              NewNewsPage(),
              BestNewsPage(),
              TopNewsPage(),
            ],
          ),
        ));
  }
}
