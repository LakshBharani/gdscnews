import 'package:flutter/material.dart';
import 'package:gdscnews/news.service.dart';
import 'package:gdscnews/screens/home/news.data.widget.dart';
import 'package:gdscnews/screens/home/shimmer.dart';

class BestNewsPage extends StatefulWidget {
  const BestNewsPage({super.key});

  @override
  State<BestNewsPage> createState() => _BestNewsPageState();
}

class _BestNewsPageState extends State<BestNewsPage> {
  List<dynamic> news = [];
  Map<int, dynamic> allNewsData = {};
  int newsLimit = 100;

  @override
  Widget build(BuildContext context) {
    fetchBestNewsWithLimit(newsLimit).then((value) {
      setState(() {
        news = value;
      });
      // Once new news is fetched, fetch details for each news item
      fetchNewsDetails();
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              final newsId = news[index];
              final newsData = allNewsData[newsId];

              // Display loading indicator if data is not yet fetched
              if (newsData == null) {
                return const ShimmerContainer();
              }

              // Display news item once data is fetched
              return NewsDataListTile(newsData: newsData);
            },
          ),
        ),
      ],
    );
  }

  void fetchNewsDetails() {
    // Fetch details for each news item asynchronously
    for (int newsId in news) {
      if (allNewsData[newsId] == null) {
        fetchNewsById(newsId).then((value) {
          setState(() {
            allNewsData[newsId] = value;
          });
        });
      }
    }
  }
}
