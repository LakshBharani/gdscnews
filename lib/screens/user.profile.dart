import 'package:flutter/material.dart';
import 'package:gdscnews/news.service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:html/parser.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map allUserData = {};
  List<dynamic> otherNewsIds = [];
  int lenAllNews = 0;
  Map<String, dynamic> allNewsData = {};

  // access the arguments passed by navigator
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (allUserData.isEmpty) {
      fetchUserById(args['userId']).then((value) {
        setState(() {
          allUserData = value;
        });
      });
    }

    if (otherNewsIds.isEmpty) {
      fetchUserById(args['userId']).then((value) {
        setState(() {
          otherNewsIds = value["submitted"];
          lenAllNews = otherNewsIds.length;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label("User ID"),
                Text(
                  args['userId'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                label("Member Since"),
                getMemberSince("created"),
                label("Karma"),
                getKarma("karma"),
                allUserData["about"] != null ? label("About") : Container(),
                allUserData["about"] != null ? getAbout() : Container(),
                label("More by ${args['userId']}"),
                getMoreNews(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getMemberSince(String fieldKey) {
    return allUserData[fieldKey] == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 110,
              height: 20,
              color: Colors.white,
            ),
          )
        : Text(
            allUserData[fieldKey] != null
                ? DateTime.fromMillisecondsSinceEpoch(
                        allUserData[fieldKey] * 1000)
                    .toString()
                    .substring(0, 10)
                : "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
  }

  Widget getKarma(String fieldKey) {
    return allUserData[fieldKey] == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 110,
              height: 20,
              color: Colors.white,
            ),
          )
        : Text(
            allUserData[fieldKey] != null
                ? allUserData[fieldKey].toString()
                : "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
  }

  Widget getAbout() {
    return allUserData["about"] == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 110,
              height: 20,
              color: Colors.white,
            ),
          )
        : Text(
            parse("${allUserData["about"]}").documentElement!.text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          );
  }

  // Widget otherNewsByUser() {
  //   return otherNewsIds.isEmpty
  //       ? Shimmer.fromColors(
  //           baseColor: Colors.grey.shade300,
  //           highlightColor: Colors.grey.shade100,
  //           child: Container(
  //             width: 110,
  //             height: 20,
  //             color: Colors.white,
  //           ),
  //         )
  //       : SizedBox(
  //           height: 600,
  //           child: ListView.builder(
  //             itemCount: maxNumberOfOtherUsers,
  //             itemBuilder: (context, index) {
  //               final newsId = otherNewsIds[index];
  //               fetchNewsById(newsId).then((value) {
  //                 setState(() {
  //                   allTitles.add(value["title"]);
  //                   allSubTitles.add(value["url"]);
  //                 });
  //               });
  //               return allTitles[index] != null && allSubTitles[index] != null
  //                   ? ListTile(
  //                       title: Text(
  //                         allTitles[index].toString(),
  //                         style: const TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       subtitle: Text(
  //                         allSubTitles[index].toString(),
  //                         style: const TextStyle(
  //                           fontSize: 14,
  //                           color: Colors.black54,
  //                         ),
  //                       ),
  //                     )
  //                   : null;
  //             },
  //           ),
  //         );
  // }

  Future getAllMoreNews() async {
    int counter = 0;
    if (allNewsData.isEmpty) {
      for (int i = 0; i < lenAllNews; i++) {
        await fetchNewsById(otherNewsIds[i]).then((value) {
          if (value["title"] != null && value["url"] != null) {
            setState(() {
              allNewsData[counter.toString()] = [value["title"], value["url"]];
              counter++;
            });
          }
        });
      }
    }
    print(allNewsData);

    return Future.value(allNewsData);
  }

  Widget getMoreNews() {
    return SizedBox(
      height: 600,
      // child: ListView.builder(
      //     itemCount: allTitles.length,
      //     itemBuilder: (context, index) {
      //       return ListTile(title: Text(allTitles[index]));
      //     }),
      child: FutureBuilder(
        future: getAllMoreNews(),
        builder: (context, index) {
          if (allNewsData.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: allNewsData.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  allNewsData[index.toString()][0].toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  allNewsData[index.toString()][1].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Widget label(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.deepPurple,
      ),
    ),
  );
}
