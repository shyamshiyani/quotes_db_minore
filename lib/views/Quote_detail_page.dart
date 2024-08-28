import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class QuoteDetailPage extends StatefulWidget {
  const QuoteDetailPage({super.key});

  @override
  State<QuoteDetailPage> createState() => _QuoteDetailPageState();
}

class _QuoteDetailPageState extends State<QuoteDetailPage> {
  Color selFontColor = Colors.black;
  Alignment selAlignment = Alignment.centerLeft;
  double fontSize = 18.0;
  FontWeight selFontWeight = FontWeight.normal;
  FontStyle selFontStyle = FontStyle.normal;
  Color selBackgroundColor = Colors.white;
  final GlobalKey repaintKey = GlobalKey();

  // Define default values
  Color defaultFontColor = Colors.black;
  Color defaultBackgroundColor = Colors.white;
  Alignment defaultAlignment = Alignment.center;
  double defaultFontSize = 16.0;
  FontWeight defaultFontWeight = FontWeight.normal;
  FontStyle defaultFontStyle = FontStyle.normal;

  @override
  void initState() {
    super.initState();
    // Initialize with default values
    selFontColor = defaultFontColor;
    selBackgroundColor = defaultBackgroundColor;
    selAlignment = defaultAlignment;
    fontSize = defaultFontSize;
    selFontWeight = defaultFontWeight;
    selFontStyle = defaultFontStyle;
  }

  Future<void> shareImage() async {
    RenderRepaintBoundary boundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List uint8List = byteData!.buffer.asUint8List();
    Directory directory = await getTemporaryDirectory();
    String path = '${directory.path}/quote.png';
    File file = File(path);
    file.writeAsBytesSync(uint8List);
    ShareExtend.share(path, "image");
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Quote Detail",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade700,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  selFontColor = defaultFontColor;
                  selBackgroundColor = defaultBackgroundColor;
                  selAlignment = defaultAlignment;
                  fontSize = defaultFontSize;
                  selFontWeight = defaultFontWeight;
                  selFontStyle = defaultFontStyle;
                });
              },
            ),
          ],
          elevation: 0, // Optional: removes the shadow for a flat look
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: repaintKey,
                child: Container(
                  alignment: Alignment.center,
                  height: 271,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: selBackgroundColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 5.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                    image: selBackgroundColor != Colors.white
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://www.shutterstock.com/image-photo/wooden-footbridge-on-lake-mist-260nw-1238469448.jpg")),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['quote'] ?? "No quote available",
                            style: TextStyle(
                              fontSize: fontSize,
                              color: selFontColor,
                              fontWeight: selFontWeight,
                              fontStyle: selFontStyle,
                            ),
                            textAlign: selAlignment == Alignment.centerLeft
                                ? TextAlign.left
                                : selAlignment == Alignment.centerRight
                                    ? TextAlign.right
                                    : TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "- ${data['author'] ?? 'Unknown'}",
                              style: TextStyle(
                                fontSize: fontSize -
                                    2, // Slightly smaller font size for author
                                color: selFontColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await FlutterClipboard.copy(
                                      data['quote'] ?? '');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Copied to clipboard!"),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy),
                                color: Colors.blueGrey.shade700,
                              ),
                              IconButton(
                                onPressed: () async {
                                  await shareImage();
                                },
                                icon: const Icon(Icons.share),
                                color: Colors.blueGrey.shade700,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Change Font Color",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Colors.primaries.map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selFontColor = color;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black87,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Change Background Color",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Colors.accents.map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selBackgroundColor = color;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black87,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Change Alignment",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selAlignment = Alignment.centerLeft;
                            });
                          },
                          icon: const Icon(Icons.format_align_left),
                          color: Colors.blueGrey.shade700,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selAlignment = Alignment.center;
                            });
                          },
                          icon: const Icon(Icons.format_align_center),
                          color: Colors.blueGrey.shade700,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selAlignment = Alignment.centerRight;
                            });
                          },
                          icon: const Icon(Icons.format_align_right),
                          color: Colors.blueGrey.shade700,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Adjust Font Size",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (fontSize > 8.0) {
                                fontSize -= 2.0; // Minimum font size
                              }
                            });
                          },
                          icon: const Icon(Icons.remove),
                          color: Colors.blueGrey.shade700,
                        ),
                        Text(
                          '${fontSize.toInt()}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (fontSize < 72.0) {
                                fontSize += 2.0; // Maximum font size
                              }
                            });
                          },
                          icon: const Icon(Icons.add),
                          color: Colors.blueGrey.shade700,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Change Font Weight",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selFontWeight = FontWeight.normal;
                            });
                          },
                          icon: const Icon(Icons.format_bold),
                          color: Colors.blueGrey.shade700,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selFontWeight = FontWeight.bold;
                            });
                          },
                          icon: const Icon(Icons.format_bold),
                          color: Colors.blueGrey.shade700,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selFontWeight = FontWeight.w300;
                            });
                          },
                          icon: const Icon(Icons.format_italic),
                          color: Colors.blueGrey.shade700,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Change Font Style",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selFontStyle = FontStyle.normal;
                            });
                          },
                          icon: const Icon(Icons.format_italic),
                          color: Colors.blueGrey.shade700,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selFontStyle = FontStyle.italic;
                            });
                          },
                          icon: const Icon(Icons.format_italic),
                          color: Colors.blueGrey.shade700,
                        ),
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
