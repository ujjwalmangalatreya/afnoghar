

import 'package:flutter/material.dart';
import 'package:hamroghar/model/posting_model.dart';

class PostingListTileUi extends StatefulWidget {
  final PostingModel? posting;
   const PostingListTileUi({super.key,this.posting});

  @override
  State<PostingListTileUi> createState() => _PostingListTileUiState();
}

class _PostingListTileUiState extends State<PostingListTileUi> {
    PostingModel? posting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    posting = widget.posting;
  }
  @override
  Widget build(BuildContext context) {
    // Check if posting is null and handle it
    if (posting == null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: const Text(
            "No posting available",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.error, color: Colors.red),
        ),
      );
    }
    return
      Padding(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            posting!.name!,
            maxLines: 2,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: AspectRatio(
            aspectRatio: 3/2,
          child: Image(
              image: posting!.displayImages!.first,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
