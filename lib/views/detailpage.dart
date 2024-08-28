import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Set<int> _likedQuotes = {};

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final List quotes = data?['quotes'] ?? [];
    final String title = data?['name'] ?? "No Title";

    return Scaffold(
      appBar: AppBar(
        title: Text("$title Quotes"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).pushNamed(
                'liked_quotes',
                arguments: _likedQuotes.map((index) => quotes[index]).toList(),
              );
            },
          ),
        ],
      ),
      body: quotes.isEmpty
          ? Center(
              child: Text(
                'No quotes available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueGrey.shade600,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final quote = quotes[index];
                final isLiked = _likedQuotes.contains(index);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        "quote_detail",
                        arguments: quote,
                      );
                    },
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
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.blueGrey.shade600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            IconButton(
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (isLiked) {
                                    _likedQuotes.remove(index);
                                  } else {
                                    _likedQuotes.add(index);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
