import 'package:flutter/material.dart';

class ListingInfoTileUi extends StatefulWidget {

  IconData? iconData;
  String? category;
  String? categoryInfo;

  ListingInfoTileUi({super.key,this.iconData,this.category,this.categoryInfo});

  @override
  State<ListingInfoTileUi> createState() => _ListingInfoTileUiState();
}

class _ListingInfoTileUiState extends State<ListingInfoTileUi> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        widget.iconData,
        size: 30,
      ),
      title: Text(
        widget.category!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      subtitle: Text(
        widget.categoryInfo!,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
