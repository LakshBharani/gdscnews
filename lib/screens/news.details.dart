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
                setState(() {
                  isBookmarked = !isBookmarked;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    action: SnackBarAction(
                      label: "View",
                      onPressed: () {
                        Navigator.pushNamed(context, '/bookmarks');
                      },
                    ),
                    content: Text(
                      isBookmarked
                          ? "Added to bookmarks"
                          : "Removed from bookmarks",
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
                print(
                    dbHelper.getBookmarkedNews().then((value) => print(value)));
              },
              icon: checkBookmarked()
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
          : newsURL == ""
              ? const Center(child: Text("No URL found for this news."))
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

  void bookMarkPressHandler(Map args) async {
    isBookmarked
        ? dbHelper.deleteNews(args['newsId'])
        : {
            await fetchNewsById(args['newsId']).then((value) => {
                  dbHelper.saveNews({
                    "id": args['newsId'],
                    "title": newsTitle,
                    "url": newsURL,
                    "score": value['score'],
                    "descendants": value['descendants'],
                    "time": value['time'],
                    "by": value['by'],
                    "type": value['type'],
                    "deleted": value['deleted'],
                    "dead": value['dead'],
                    "parent": value['parent'],
                    "poll": value['poll'],
                    "kids": value['kids'],
                    "parts": value['parts'],
                    "descendantsList": value['descendantsList'],
                    "timeAgo": value['timeAgo'],
                    "bookmarked": isBookmarked ? 1 : 0,
                  })
                })
          };
  }
}
