import 'package:flutter/material.dart';

class LikedQuotesPage extends StatefulWidget {
  const LikedQuotesPage({Key? key}) : super(key: key);

  @override
  _LikedQuotesPageState createState() => _LikedQuotesPageState();
}

class _LikedQuotesPageState extends State<LikedQuotesPage> {
  List<dynamic> likedQuotes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>?;
    if (arguments != null) {
      setState(() {
        likedQuotes = arguments;
      });
    }
  }

  void _removeQuote(int index) {
    setState(() {
      likedQuotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liked Quotes"),
        backgroundColor: Colors.blueGrey.shade700,
      ),
      body: likedQuotes.isEmpty
          ? Center(
              child: Text(
                'No liked quotes available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueGrey.shade600,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: likedQuotes.length,
              itemBuilder: (context, index) {
                final quote = likedQuotes[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? Colors.blueGrey.shade50
                            : Colors.blueGrey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quote['quote'] ?? 'No quote provided',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "- ${quote['author'] ?? 'Unknown author'}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              onPressed: () => _removeQuote(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
