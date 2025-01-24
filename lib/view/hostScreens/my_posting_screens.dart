
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamroghar/global.dart';
import 'package:hamroghar/model/app_constants.dart';
import 'package:hamroghar/view/hostScreens/create_posting_screens.dart';
import 'package:hamroghar/widgets/posting_list_tile_button.dart';
import 'package:hamroghar/widgets/posting_list_tile_ui.dart';

class MyPostingScreens extends StatefulWidget {
   MyPostingScreens({super.key});

  @override
  State<MyPostingScreens> createState() => _MyPostingScreensState();
}

class _MyPostingScreensState extends State<MyPostingScreens> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: ListView.builder(
        itemCount: AppConstants.currentUser.myPostings!.length + 1,
          itemBuilder:(context,index){
            return Padding(
              padding: const EdgeInsets.fromLTRB(26, 0, 26, 26),
              child: InkResponse(
                onTap: (){
                  Get.to(()=>CreatePostingScreens(
                        posting: (index == AppConstants.currentUser.myPostings!.length)
                            ? null
                            : AppConstants.currentUser.myPostings![index],

                  ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.2,
                      )
                  ),
                  child:(index == AppConstants.currentUser.myPostings!.length)
                      ?  PostingListTileButton()
                      : PostingListTileUi(posting: postingModel,
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
