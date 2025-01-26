import 'package:flutter/material.dart';
import 'package:hamroghar/model/posting_model.dart';

class PostingListTileUi extends StatefulWidget {
   PostingModel? posting;
   PostingListTileUi({super.key, this.posting});

  @override
  State<PostingListTileUi> createState() => _PostingListTileUiState();
}

class _PostingListTileUiState extends State<PostingListTileUi> {
  PostingModel? posting;

  @override
  void initState() {
    super.initState();
    posting = widget.posting;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            posting!.name ?? "No Name Available", // Fallback for name
            maxLines: 2,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: AspectRatio(
          aspectRatio: 3 / 2,
          child: (posting?.displayImages != null && posting!.displayImages!.isNotEmpty)
              ? (posting!.displayImages!.first is String
              ? Image.network(
            posting!.displayImages!.first as String, // If it's a URL
            fit: BoxFit.fitWidth,
          )
              : Image.memory(
            posting!.displayImages!.first.bytes, // If it's a MemoryImage
            fit: BoxFit.fitWidth,
          ))
              : const Icon(
            Icons.image_not_supported,
            color: Colors.grey, // Fallback icon for empty or null images
          ),
        ),
      ),
    );
  }
}
