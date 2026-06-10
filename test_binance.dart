import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final _restApiUrl = 'https://api.binance.com/api/v3/ticker/24hr';
  try {
    final response = await http.get(Uri.parse(_restApiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      int count = 0;
      for (var item in data) {
        final symbol = item['symbol'] as String;
        if (symbol.endsWith('USDT')) {
          final volume = double.tryParse(item['quoteVolume'].toString()) ?? 0.0;
          if (volume > 1000000) {
            count++;
          }
        }
      }
      print('Found $count crypto pairs');
    } else {
      print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
