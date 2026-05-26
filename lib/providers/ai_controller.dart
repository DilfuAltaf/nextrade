import 'dart:math';
import 'package:get/get.dart';
import 'package:nextrade/providers/market_controller.dart';

class AiController extends GetxController {
  final MarketController _marketController = Get.find();

  final recommendations = <Map<String, dynamic>>[].obs;
  final candlePatterns = <Map<String, dynamic>>[].obs;
  final marketSentiment = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    generateRecommendations();
  }

  void generateRecommendations() {
    final rng = Random();
    final topMarkets = _marketController.markets.take(5).toList();

    recommendations.value = topMarkets.map((market) {
      final signal = rng.nextDouble();
      String type;
      if (signal < 0.4) {
        type = 'Beli';
      } else if (signal < 0.7) {
        type = 'Hold';
      } else {
        type = 'Jual';
      }

      final target1 = market.price * (1 + (rng.nextDouble() - 0.3) * 0.1);
      final target2 = market.price * (1 + (rng.nextDouble() - 0.2) * 0.15);
      final stopLoss = market.price * (1 - (rng.nextDouble() * 0.05));
      final potential = ((target1 - market.price) / market.price * 100).abs();

      return {
        'type': type,
        'asset': market,
        'entry': '\$${(market.price * 0.98).toStringAsFixed(2)} - \$${(market.price * 1.02).toStringAsFixed(2)}',
        'target1': '\$${target1.toStringAsFixed(2)}',
        'target2': '\$${target2.toStringAsFixed(2)}',
        'stopLoss': '\$${stopLoss.toStringAsFixed(2)}',
        'potential': '${potential.toStringAsFixed(1)}%',
        'title': '$type ${market.symbol}',
        'pair': '${market.symbol}/USDT',
      };
    }).toList();

    candlePatterns.value = [
      {
        'pattern': 'Bullish Engulfing',
        'description': 'Terdeteksi pada candle terakhir. Pola ini mengindikasikan potensi pembalikan harga ke arah bullish.',
        'type': 'bullish',
      },
      {
        'pattern': 'Hammer',
        'description': 'Candle dengan shadow panjang bawah menandakan tekanan beli yang kuat di area support.',
        'type': 'bullish',
      },
      {
        'pattern': 'Doji',
        'description': 'Pola keraguan dimana harga open dan close hampir sama. Perhatikan konfirmasi selanjutnya.',
        'type': 'neutral',
      },
    ];

    marketSentiment.value = 'Bullish';
  }

  String get marketAnalysis {
    return 'BTC menunjukkan golden cross pada MA 50 dan MA 200. RSI berada di level 62 menandakan momentum bullish masih kuat. Support terdekat di \$65,000 dan resistance di \$68,500.';
  }

  String get fundamentalAnalysis {
    return 'Adopsi institutional terus meningkat. Bitcoin ETF mencatat inflow positif selama 7 hari berturut-turut. Sentimen pasar crypto secara umum positif.';
  }

  String get sentimentAnalysis {
    return 'Social media sentiment: 72% positif. Fear & Greed Index: 65 (Greed). Volume trading meningkat 15% dari rata-rata 7 hari.';
  }
}
