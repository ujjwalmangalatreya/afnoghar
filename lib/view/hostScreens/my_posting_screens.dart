
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamroghar/view/hostScreens/create_posting_screens.dart';
import 'package:hamroghar/widgets/posting_list_time.dart';

class MyPostingScreens extends StatefulWidget {
  const MyPostingScreens({super.key});

  @override
  State<MyPostingScreens> createState() => _MyPostingScreensState();
}

class _MyPostingScreensState extends State<MyPostingScreens> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 0, 26, 26),
        child: InkResponse(
          onTap: (){
            Get.to(()=>CreatePostingScreens());
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.2,
              )
            ),
            child: PostingListTile(),
          ),
        ),
      ),
    );
  }
}
