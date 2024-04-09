import 'package:flutter/material.dart';
import 'package:gdscnews/models/dbhelper.dart';
import 'package:gdscnews/news.service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailsPage extends StatefulWidget {
  const NewsDetailsPage({super.key});

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  String newsTitle = "";
  String newsURL = "";
  bool isBookmarked = false;

  DatabaseHelper dbHelper = DatabaseHelper();

  bool checkBookmarked() {
    dbHelper.getBookmarkedNews().then((value) {
      for (var element in value) {
        if (element['title'] == newsTitle) {
          setState(() {
            isBookmarked = true;
          });
        }
      }
    });
    return isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    isBookmarked = checkBookmarked();

    newsTitle == "" ? getNewsDetails(args) : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(newsTitle),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                bookMarkPressHandler(args);
                print(
                    dbHelper.getBookmarkedNews().then((value) => print(value)));
                setState(() {
                  isBookmarked = !isBookmarked;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isBookmarked
                          ? "Added to bookmarks"
                          : "Removed from bookmarks",
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              icon: isBookmarked
                  ? Icon(
                      Icons.bookmark_added_rounded,
                      color: Colors.yellow.shade800,
                    )
                  : const Icon(
                      Icons.bookmark_add_rounded,
                      color: Colors.black,
                    ),
            ),
          ),
        ],
      ),
      body: newsTitle == ""
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : WebView(
              initialUrl: newsURL,
              javascriptMode: JavascriptMode.unrestricted,
            ),
    );
  }

  void getNewsDetails(Map args) async {
    await fetchNewsById(args['newsId']).then((value) {
      setState(() {
        newsTitle = value['title'];
        newsURL = value['url'];
      });
    });
    print(newsTitle);
  }

  void bookMarkPressHandler(Map args) {
    isBookmarked
        ? dbHelper.deleteNews(args['newsId'])
        : dbHelper.saveNews({
            "id": args['newsId'],
            "title": newsTitle,
            "url": newsURL,
            "score": args['score'],
            "descendants": args['descendants'],
            "time": args['time'],
            "by": args['by'],
            "type": args['type'],
            "deleted": args['deleted'],
            "dead": args['dead'],
            "parent": args['parent'],
            "poll": args['poll'],
            "kids": args['kids'],
            "parts": args['parts'],
            "descendantsList": args['descendantsList'],
            "timeAgo": args['timeAgo'],
            "bookmarked": isBookmarked ? 1 : 0,
          });
  }
}
