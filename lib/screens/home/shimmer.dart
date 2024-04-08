import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListTile(
          title: Container(
            height: 20,
            width: 200,
            color: Colors.white,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 3),
                height: 20,
                width: 200,
                color: Colors.white,
              ),
              Container(
                height: 20,
                width: 200,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
