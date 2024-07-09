import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String alphaVantageApiKey = 'G93G74RMOD8NV4OS';
  final String coinMarketCapApiKey = '847d1067-a81b-4f97-8f48-e262ed934fa0';

  Future<Map<String, dynamic>> fetchStockData(String symbol) async {
    final response = await http.get(Uri.parse(
        'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=5min&apikey=$alphaVantageApiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  Future<Map<String, dynamic>> fetchCryptoData(String symbol) async {
    final response = await http.get(
      Uri.parse(
          'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=$symbol'),
      headers: {
        'X-CMC_PRO_API_KEY': coinMarketCapApiKey,
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load crypto data');
    }
  }
}
