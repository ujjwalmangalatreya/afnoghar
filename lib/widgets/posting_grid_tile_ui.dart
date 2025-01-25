import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamroghar/model/app_constants.dart';
import 'package:hamroghar/model/posting_model.dart';

class PostingGridTileUi extends StatefulWidget {
  PostingModel? posting;
   PostingGridTileUi({super.key,this.posting});

  @override
  State<PostingGridTileUi> createState() => _PostingGridTileUiState();
}

class _PostingGridTileUiState extends State<PostingGridTileUi> {

  PostingModel? posting;

  updateUI()async{
   await posting!.getFirstImageFromDatabase();
   setState(() {

   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    posting = widget.posting;
    updateUI();

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 3/2,
          child: posting!.displayImages!.isEmpty
          ? Container()
          :Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: posting!.displayImages!.first,
              ),
            ),
          ),
        ),
        Text(
          "${posting!.type} - ${posting!.city} - ${posting!.country}",
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text(
          "${posting!.name}",
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text(
         '\$${posting!.price!}/night',
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),

        Row(
          children: [
              RatingBar.readOnly(
                size: 28.0,
                maxRating: 5,
                initialRating: posting!.getCurrentRating(),
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                filledColor: Colors.pink,
              ) ],
        ),
      ],
    );
  }
}
