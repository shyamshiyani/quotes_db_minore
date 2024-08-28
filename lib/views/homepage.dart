import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'like_categoryPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<Map<String, dynamic>> jsondata;
  final List<String> likedQuotes = []; // List to store liked quotes

  Future<Map<String, dynamic>> loadData() async {
    final String response =
        await rootBundle.loadString("assets/data/all_data.json");
    return jsonDecode(response) as Map<String, dynamic>;
  }

  @override
  void initState() {
    super.initState();
    jsondata = loadData();
  }

  void likeQuote(String quote) {
    setState(() {
      likedQuotes.add(quote);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quote App"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Add search functionality here
                      },
                      icon: const Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blueGrey.shade50,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: FutureBuilder<Map<String, dynamic>>(
              future: jsondata,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("ERROR: ${snapshot.error}"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text("No data available"),
                  );
                }

                final data = snapshot.data!;
                final categories = data['categories'] as Map<String, dynamic>;

                return ListView.builder(
                  itemCount: categories.keys.length,
                  itemBuilder: (context, index) {
                    final category = categories.keys.elementAt(index);
                    final quotes = categories[category] as List<dynamic>;

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          "detail",
                          arguments: {
                            'name': category,
                            'quotes': quotes,
                          },
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 85,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? Colors.blueGrey.shade100
                                : Colors.blueGrey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            category,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
