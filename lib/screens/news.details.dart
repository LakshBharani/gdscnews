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
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    newsTitle == "" ? getNewsDetails(args) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(newsTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              icon: isFavorite
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                    )
                  : const Icon(
                      Icons.favorite_border_outlined,
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
