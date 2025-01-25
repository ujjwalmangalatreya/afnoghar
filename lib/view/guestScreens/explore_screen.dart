import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:hamroghar/appwrite.dart';
import 'package:hamroghar/model/posting_model.dart';
import 'package:hamroghar/widgets/posting_grid_tile_ui.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController controllerSearch = TextEditingController();
  String searchType = "";

  final List<Map<String, dynamic>> documents = [];
  late RealtimeSubscription subscription;
  bool isLoading = true; // To track initial loading

  bool isNameButtonSelected = false;
  bool isCityButtonSelected = false;
  bool isTypeButtonSelected = false;

  @override
  void initState() {
    super.initState();
    fetchInitialData(); // Fetch initial documents
    setupRealtimeSubscription(); // Listen for changes
  }

  /// Fetch existing documents from the database
  Future<void> fetchInitialData() async {
    try {
      final response = await AppWrite.database.listDocuments(
        databaseId: AppWrite.databaseId,
        collectionId: AppWrite.postingCollectionId,
      );

      setState(() {
        documents.addAll(response.documents.map((doc) => doc.data)); // Add fetched documents
        isLoading = false; // Loading complete
      });
    } catch (e) {
      print("Error fetching documents: $e");
      setState(() {
        isLoading = false; // Stop loading even on error
      });
    }
  }

  /// Set up Realtime subscription for live updates
  void setupRealtimeSubscription() {
    subscription = AppWrite.realtime.subscribe([
      'databases.${AppWrite.databaseId}.collections.${AppWrite.postingCollectionId}.documents',
    ]);

    subscription.stream.listen((event) {
      if (event.payload.isNotEmpty) {
        setState(() {
          documents.add(event.payload); // Add new or updated document to the list
        });
      }
    });
  }

  /// Search and filter functionality
  void pressSearchByButton(
      String searchTypeStr, bool isNameButtonSelectedB, bool isCityButtonSelectedB, bool isTypeButtonSelectedB) {
    setState(() {
      searchType = searchTypeStr;
      isCityButtonSelected = isCityButtonSelectedB;
      isNameButtonSelected = isNameButtonSelectedB;
      isTypeButtonSelected = isTypeButtonSelectedB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // SEARCHBAR
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(5.0),
                ),
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                controller: controllerSearch,
              ),
            ),

            // SEARCH BY TYPE, CITY, TYPE BUTTONS
            SizedBox(
              height: 48,
              width: MediaQuery.of(context).size.width / .5,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                children: [
                  MaterialButton(
                    onPressed: () {
                      pressSearchByButton("name", true, false, false);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: isNameButtonSelected ? Colors.pink : Colors.white,
                    child: const Text("Name"),
                  ),
                  const SizedBox(width: 6),
                  MaterialButton(
                    onPressed: () {
                      pressSearchByButton("city", false, true, false);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: isCityButtonSelected ? Colors.pink : Colors.white,
                    child: const Text("City"),
                  ),
                  const SizedBox(width: 6),
                  MaterialButton(
                    onPressed: () {
                      pressSearchByButton("type", false, false, true);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: isTypeButtonSelected ? Colors.pink : Colors.white,
                    child: const Text("Type"),
                  ),
                ],
              ),
            ),

            // DISPLAY LISTINGS
            isLoading
                ? const Center(child: CircularProgressIndicator()) // Show loading spinner
                : documents.isEmpty
                ? const Center(child: Text("No data found")) // Show empty state
                : GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: documents.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 15,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (context, index) {
                final document = documents[index];
                PostingModel cPosting = PostingModel(id: document['\$id']);
                cPosting.getPostingInformationFromPostingModel(document);

                return InkResponse(
                  onTap: () {
                    // Handle click
                  },
                  enableFeedback: true,
                  child: PostingGridTileUi(
                    posting: cPosting,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.close(); // Close Realtime subscription when the screen is disposed
    super.dispose();
  }
}
