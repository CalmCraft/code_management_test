import 'package:flutter/material.dart';

class MovieListLayoutShimmer extends StatelessWidget {
  const MovieListLayoutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 50,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 200,
            child: ListView.separated(
                padding: const EdgeInsets.only(right: 12),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 200,
                    color: Colors.grey,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 12,
                  );
                },
                itemCount: 3),
          )
        ],
      ),
    );
  }
}
