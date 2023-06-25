import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

alert_container({
  required double width,
  String? title,
  String? description,
}) {
  return Container(
    height: 100,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.90,
        enableInfiniteScroll: true,
        autoPlayInterval: const Duration(seconds: 7),
        enlargeCenterPage: true,
        scrollDirection: Axis.vertical,
      ),
      items: List.generate(
        5,
        (index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 1,
            ),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '19',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        ' June',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (title != null)
                        Text(
                          title,
                          maxLines: 2,
                          style: const TextStyle(color: Colors.white),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (description != null)
                        Text(
                          description,
                          softWrap: true,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

              

          // Container(
          //   height: 80,
          //   width: double.infinity,
          //   child: Row(
          //     children: [
          //       Container(
          //         width: 60,
          //         child: Card(
          //           child: Center(
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Text('19 '),
          //                 Text(' June'),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Card(
          //           child: Container(
          //             color: Colors.red,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // );
   