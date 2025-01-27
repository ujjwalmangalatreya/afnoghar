import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamroghar/model/app_constants.dart';
import 'package:hamroghar/model/posting_model.dart';
import 'package:hamroghar/view/view_posting_screen.dart';
import 'package:hamroghar/widgets/posting_grid_tile_ui.dart';

class SavedListingScreens extends StatefulWidget {
  const SavedListingScreens({super.key});

  @override
  State<SavedListingScreens> createState() => _SavedListingScreensState();
}

class _SavedListingScreensState extends State<SavedListingScreens> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
      child: GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: AppConstants.currentUser.savedPostings!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          PostingModel currentPosting =
              AppConstants.currentUser.savedPostings![index];
          return Stack(
            children: [
              InkWell(
                enableFeedback: true,
                child: PostingGridTileUi(
                  posting: currentPosting,
                ),
                onTap: () {
                  Get.to(
                    () => ViewPostingScreen(
                      posting: currentPosting,
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Container(
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      onPressed: () {

                        AppConstants.currentUser.removeSavedPosting(currentPosting);
                        setState(() {

                        });
                      },
                      icon: Icon(Icons.clear),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
