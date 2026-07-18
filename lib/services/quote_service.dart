import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  Future<Map<String, String>> getRandomQuote() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/quotes/random'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "quote": data["quote"] ?? "Keep learning, keep growing.",
          "author": data["author"] ?? "Unknown",
        };
      } else {
        return {"quote": "Keep learning, keep growing.", "author": "Unknown"};
      }
    } catch (e) {
      return {"quote": "Keep learning, keep growing.", "author": "Unknown"};
    }
  }
}