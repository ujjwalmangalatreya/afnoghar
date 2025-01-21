import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hamroghar/widgets/amenities_ui.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostingScreens extends StatefulWidget {
  const CreatePostingScreens({super.key});

  @override
  State<CreatePostingScreens> createState() => _CreatePostingScreensState();
}

class _CreatePostingScreensState extends State<CreatePostingScreens> {
  final formKey = GlobalKey<FormState>();
    TextEditingController _nameTextEditingController =
      TextEditingController();
   TextEditingController _priceTextEditingController =
      TextEditingController();
   TextEditingController _descriptionTextEditingController =
      TextEditingController();
   TextEditingController _addressTextEditingController =
      TextEditingController();
   TextEditingController _cityTextEditingController =
      TextEditingController();
   TextEditingController _countryTextEditingController =
      TextEditingController();
   TextEditingController _amenitiesTextEditingController =
      TextEditingController();

  final List<String> residenceType = [
    "Detached House",
    "Villa",
    "Apartment",
    "Condo",
    "Flat",
    "Town House",
    "Studio",
  ];

  String residenceTypeSelected = "";

  Map<String, int>? _beds;
  Map<String, int>? _bathrooms;

  List<MemoryImage>? _imagesList;

  _selectImageFromGallery(int index) async {
    var imageFilePickedFromGallery =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFilePickedFromGallery != null) {
      MemoryImage imageFileInByteForm = MemoryImage(
          (File(imageFilePickedFromGallery.path)).readAsBytesSync());
      if (index < 0) {
        _imagesList!.add(imageFileInByteForm);
      } else {
        _imagesList![index] = imageFileInByteForm;
      }
      setState(() {});
    }
  }

  initializeValues(){
    _nameTextEditingController = TextEditingController(text: "");
    _priceTextEditingController = TextEditingController(text: "");
    _descriptionTextEditingController = TextEditingController(text: "");
    _addressTextEditingController = TextEditingController(text: "");
    _cityTextEditingController = TextEditingController(text: "");
    _countryTextEditingController = TextEditingController(text: "");
    _amenitiesTextEditingController = TextEditingController(text: "");
    residenceTypeSelected = residenceType.first;

    _beds ={
      'small' : 0,
      'medium' : 0,
      'large' : 0
    };
    _bathrooms ={
      'full' : 0,
      'half' : 0,
    };
    _imagesList =[];

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.amber],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Create / Update a Posting",
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.upload),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(26, 26, 26, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LISTING NAME
                      Padding(
                        padding: EdgeInsets.only(top: 1.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Listing Name",
                          ),
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _nameTextEditingController,
                          validator: (textInput) {
                            if (textInput!.isEmpty) {
                              return "Please enter a valid Name";
                            }
                            return null;
                          },
                        ),
                      ),
                      //SELECT PROPERTY TYPE
                      Padding(
                        padding: EdgeInsets.only(top: 28.0),
                        child: DropdownButton(
                          items: residenceType.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (valueItem) {
                            setState(() {
                              residenceTypeSelected = valueItem.toString();
                            });
                          },
                          isExpanded: true,
                          value: residenceTypeSelected,
                          hint: Text(
                            "Select property type",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      //PRICE PER NIGHT
                      Padding(
                        padding: EdgeInsets.only(top: 21.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Price",
                                ),
                                style: TextStyle(
                                  fontSize: 25.0,
                                ),
                                keyboardType: TextInputType.number,
                                controller: _priceTextEditingController,
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return "Please enter a valid price";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 10.0, bottom: 10.0),
                              child: Text(
                                "\$ / night",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // DESCRIPTION ABOUT THE LISTING
                      Padding(
                        padding: EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Description"),
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _descriptionTextEditingController,
                          maxLines: 3,
                          minLines: 1,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Please enter a valid description";
                            }
                            return null;
                          },
                        ),
                      ),
                      //ADDRESS
                      Padding(
                        padding: EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Address"),
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _addressTextEditingController,
                          maxLines: 3,
                          minLines: 1,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Please enter a valid address";
                            }
                            return null;
                          },
                        ),
                      ),
                      //BEDS
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: Text(
                          "Beds",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 21.0, left: 15.0, right: 15.0),
                        child: Column(
                          children: <Widget>[
                            //TWIN/SINGLE BED
                            AmenitiesUi(
                              type: 'Twin/Single',
                              startValue: _beds!['small']!,
                              decreasedValue: () {
                                _beds!['small'] = _beds!['small']! - 1;
                                if (_beds!['small']! < 0) {
                                  _beds!['small'] = 0;
                                }
                              },
                              increaseValue: () {
                                _beds!['small'] = _beds!['small']! + 1;
                              },
                            ),
                            //DOUBLE BED
                            AmenitiesUi(
                              type: 'Double',
                              startValue: _beds!['medium']!,
                              decreasedValue: () {
                                _beds!['medium'] = _beds!['medium']! - 1;
                                if (_beds!['medium']! < 0) {
                                  _beds!['medium'] = 0;
                                }
                              },
                              increaseValue: () {
                                _beds!['medium'] = _beds!['medium']! + 1;
                              },
                            ),
                            // QUEEN?KING BED
                            AmenitiesUi(
                              type: 'Queen/King',
                              startValue: _beds!['large']!,
                              decreasedValue: () {
                                _beds!['large'] = _beds!['large']! - 1;
                                if (_beds!['large']! < 0) {
                                  _beds!['large'] = 0;
                                }
                              },
                              increaseValue: () {
                                _beds!['large'] = _beds!['large']! + 1;
                              },
                            ),
                          ],
                        ),
                      ),
                      //BATHROOMS
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Bathrooms',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
                        child: Column(
                          children: <Widget>[
                            //FULL BATHROOM
                            AmenitiesUi(
                              type: 'Full',
                              startValue: _bathrooms!['full']!,
                              decreasedValue: () {
                                _bathrooms!['full'] = _bathrooms!['full']! - 1;
                                if (_bathrooms!['full']! < 0) {
                                  _bathrooms!['full'] = 0;
                                }
                              },
                              increaseValue: () {
                                _bathrooms!['full'] = _bathrooms!['full']! + 1;
                              },
                            ),
                            // HALF BATHROOM
                            AmenitiesUi(
                              type: 'Half',
                              startValue: _bathrooms!['half']!,
                              decreasedValue: () {
                                _bathrooms!['half'] = _bathrooms!['half']! - 1;
                                if (_bathrooms!['half']! < 0) {
                                  _bathrooms!['half'] = 0;
                                }
                              },
                              increaseValue: () {
                                _bathrooms!['half'] = _bathrooms!['half']! + 1;
                              },
                            ),
                          ],
                        ),
                      ),

                      //EXTRA AMENITIES
                      Padding(
                        padding: EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Amenities,(coma separated)"),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          controller: _amenitiesTextEditingController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Please enter valid amenities (coma separated)";
                            }
                            return null;
                          },
                          maxLines: 3,
                          minLines: 1,
                        ),
                      ),

                      //PHOTOS
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 25.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: _imagesList!.length + 1,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 25,
                            crossAxisSpacing: 25,
                            childAspectRatio: 3 / 2,
                          ),
                          itemBuilder: (context, index) {
                            if (index == _imagesList!.length) {
                              return IconButton(
                                onPressed: () {
                                  _selectImageFromGallery(-1);
                                },
                                icon: Icon(Icons.add),
                              );
                            }
                            return MaterialButton(
                              onPressed: () {},
                              child: Image(
                                image: _imagesList![index],
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
