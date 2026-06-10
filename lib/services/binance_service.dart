import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nextrade/models/market_model.dart';

class BinanceService {
  final String _restApiUrl = 'https://api.binance.com/api/v3/ticker/24hr';
  final String _wsUrl = 'wss://stream.binance.com:9443/ws/!miniTicker@arr';
  WebSocketChannel? _channel;
  
  // Gets all 24hr ticker data and converts USDT pairs to MarketModel
  Future<List<MarketModel>> getInitialCryptos() async {
    try {
      final response = await http.get(Uri.parse(_restApiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<MarketModel> cryptos = [];
        
        for (var item in data) {
          final symbol = item['symbol'] as String;
          if (symbol.endsWith('USDT')) {
            final price = double.tryParse(item['lastPrice'].toString()) ?? 0.0;
            final change = double.tryParse(item['priceChangePercent'].toString()) ?? 0.0;
            final high = double.tryParse(item['highPrice'].toString()) ?? 0.0;
            final low = double.tryParse(item['lowPrice'].toString()) ?? 0.0;
            final volume = double.tryParse(item['quoteVolume'].toString()) ?? 0.0;
            
            // Limit to pairs that have reasonable volume to filter out dead coins
            if (volume > 1000000) { // Volume > 1M USDT
              cryptos.add(MarketModel(
                id: symbol.toLowerCase(),
                name: symbol.replaceAll('USDT', ''),
                symbol: symbol,
                price: price,
                change: change,
                high24h: high,
                low24h: low,
                volume: volume,
                category: 'Crypto',
              ));
            }
          }
        }
        
        // Sort by volume descending and take top 300
        cryptos.sort((a, b) => b.volume.compareTo(a.volume));
        if (cryptos.length > 300) {
          return cryptos.sublist(0, 300);
        }
        return cryptos;
      } else {
        print('Failed to load crypto data from Binance: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching initial cryptos: $e');
      return [];
    }
  }

  // Connects to WebSocket and yields map of symbol -> updated data
  Stream<Map<String, dynamic>> connectWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
    
    return _channel!.stream.map((event) {
      final data = json.decode(event) as List<dynamic>;
      final Map<String, dynamic> updates = {};
      
      for (var item in data) {
        final symbol = item['s'] as String;
        if (symbol.endsWith('USDT')) {
          final close = double.tryParse(item['c'].toString()) ?? 0.0;
          final open = double.tryParse(item['o'].toString()) ?? 0.0;
          final change = open > 0 ? ((close - open) / open) * 100 : 0.0;
          
          updates[symbol] = {
            'price': close,
            'high24h': double.tryParse(item['h'].toString()) ?? 0.0,
            'low24h': double.tryParse(item['l'].toString()) ?? 0.0,
            'volume': double.tryParse(item['q'].toString()) ?? 0.0,
            'change': change,
          };
        }
      }
      return updates;
    });
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
