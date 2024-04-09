import 'package:flutter/material.dart';
import 'package:gdscnews/models/dbhelper.dart';
import 'package:gdscnews/screens/home/news.data.widget.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<dynamic> bookmarks = [];

  void getBookmarkedNews() {
    dbHelper.getBookmarkedNews().then((value) {
      setState(() {
        bookmarks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getBookmarkedNews();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shadowColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          return NewsDataListTile(newsData: bookmarks[index]);
        },
      ),
    );
  }
}
