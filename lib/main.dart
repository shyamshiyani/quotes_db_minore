import 'package:flutter/material.dart';
import 'package:quotes_db_miner/views/Quote_detail_page.dart';
import 'package:quotes_db_miner/views/detailpage.dart';
import 'package:quotes_db_miner/views/homepage.dart';
import 'package:quotes_db_miner/views/like_categoryPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const Homepage(),
      'detail': (context) => const DetailPage(),
      'quote_detail': (context) => const QuoteDetailPage(),
      'liked_quotes': (context) => LikedQuotesPage(),
    },
  ));
}
