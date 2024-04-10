import 'package:flutter/cupertino.dart';
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
  List<dynamic> news_copy = [];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future getNews() async {
      news = await fetchBestNewsWithLimit(newsLimit);
      setState(() {
        news_copy = news;
      });
      fetchNewsDetails();
      return news;
    }

    if (news.isEmpty) {
      getNews();
    }

    Future getFilteredNews(String value) async {
      value.isEmpty
          ? setState(() {
              news = news_copy;
            })
          : setState(() {
              news = news_copy;
              news = news
                  .where((element) => allNewsData[element]['title']
                      .toLowerCase()
                      .contains(value.toLowerCase()))
                  .toList();
            });
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoSearchTextField(
            controller: searchController,
            placeholder: 'Search news',
            onSubmitted: (value) {
              getFilteredNews(value);
            },
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: getFilteredNews(searchController.text),
            builder: (context, snapshot) {
              return ListView.builder(
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
              );
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
