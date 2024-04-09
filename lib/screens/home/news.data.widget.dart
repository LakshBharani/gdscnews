import 'package:flutter/material.dart';

class NewsDataListTile extends StatelessWidget {
  const NewsDataListTile({super.key, required this.newsData});

  final Map<String, dynamic> newsData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/news-details', arguments: {
              'newsId': newsData['id'],
            });
          },
          child: ListTile(
            trailing: points(),
            title: Text(
              newsData['title'] ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500, height: 1.2),
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 3),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/user-profile', arguments: {
                        'userId': newsData['by'],
                      });
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        const Icon(
                          Icons.person_rounded,
                          color: Colors.deepPurple,
                          size: 18,
                        ),
                        Text(
                          " : ${newsData['by']}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.comment,
                    color: Colors.deepPurple,
                    size: 18,
                  ),
                  Text(" : ${newsData['descendants']}",
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ),
        const Divider(indent: 10, endIndent: 10, height: 3),
      ],
    );
  }

  Widget points() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(3, 2, 5, 2),
        decoration: const BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            const Icon(
              Icons.star,
              color: Colors.white,
              size: 13,
            ),
            const SizedBox(width: 2),
            Text(
              newsData['score'].toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
