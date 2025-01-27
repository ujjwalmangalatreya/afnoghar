import 'package:flutter/material.dart';
import 'package:hamroghar/model/app_constants.dart';
import 'package:hamroghar/model/posting_model.dart';
import 'package:hamroghar/widgets/listing_info_tile_ui.dart';


class ViewPostingScreen extends StatefulWidget {

  PostingModel? posting;
  ViewPostingScreen({super.key,this.posting});

  @override
  State<ViewPostingScreen> createState() => _ViewPostingScreenState();
}

class _ViewPostingScreenState extends State<ViewPostingScreen> {
  PostingModel? posting;

  getRequiredInfo() async{
    await posting?.getAppPostingImagesFromDatabase();
    await posting?.getHostFromDatabase();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    posting = widget.posting;
    getRequiredInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.pinkAccent,
                  Colors.amber,
                ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0,0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),

        title: Text("Posting Information",style: TextStyle(
          color: Colors.white,
        ),),
        actions: [
          IconButton(onPressed: (){
                AppConstants.currentUser.addSavedPostings(posting!);
          },
              icon: Icon(Icons.save),
          color: Colors.white,

          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //IMAGE
            AspectRatio(
              aspectRatio: 3/2,
              child: PageView.builder(
                itemCount: posting!.displayImages!.length,
                itemBuilder: (context,index){
                  MemoryImage currentImage = posting!.displayImages![index];
                  return Image(
                    image: currentImage,
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // POSTING NAME BUTTON, BOOK NOW BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.65,
                        child: Text(
                          posting!.name!.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 3,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.pinkAccent,
                                    Colors.amber,
                                  ],
                                begin: FractionalOffset(0.0, 0.0),
                                end: FractionalOffset(1.0, 0.0),
                                stops: [0.0,1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: MaterialButton(
                                onPressed: (){},
                              child: Text("Book Now",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              ),
                            ),
                          ),
                          Text(
                            '\$${posting!.price}/Night',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                  //DESCRIPTION - PROFILE PIC
                  Padding(
                    padding: EdgeInsets.only(top: 25.0,bottom: 25.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width /1.75,
                          child: Text(
                            posting!.description!,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: (){},
                              child: CircleAvatar(
                                radius: MediaQuery.of(context).size.width /12.5,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  backgroundImage: posting!.host!.displayImage,
                                  radius: MediaQuery.of(context).size.width /13,
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                posting!.host!.getFullNameOfUser(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //APARTMENTS-BEDS-BATHROOMS
                  Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListingInfoTileUi(
                          iconData: Icons.home,
                          category: posting!.type!,
                          categoryInfo: '${posting!.getGuestNumber()} guests',
                        ),
                        ListingInfoTileUi(
                          iconData: Icons.hotel,
                          category: "Beds",
                          categoryInfo: posting!.getBedRoomText(),
                        ),
                        ListingInfoTileUi(
                          iconData: Icons.wc,
                          category: "Bathrooms",
                          categoryInfo: posting!.getBathroomText(),
                        ),
                      ],
                    ),
                  ),
                  //AMENITIES
                  Text(
                    "Amenities",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0,bottom: 25.0),
                    child: GridView.count(
                        shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 3.2,
                      children: List.generate(
                        posting!.amenities!.length,(index){
                          String currentAmenities = posting!.amenities![index];
                          return Chip(
                            label: Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                currentAmenities,
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
                          );
                      }
                      ),
                    ),

                  ),
                  //LOCATION
                  Text(
                    "Location",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0,bottom: 8),
                    child: Text(
                      posting!.getFullAddress(),
                      style: TextStyle(
                        fontSize: 15,
                      ),

                    ),
                  ),


                ],
              ),
            ),








          ],
        ),
      ),
    );
  }
}
