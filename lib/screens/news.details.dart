import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

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
                setState(() {
                  isBookmarked = !isBookmarked;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isBookmarked
                          ? "Added to favorites"
                          : "Removed from favorites",
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
}
