import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/providers/trading_controller.dart';
import 'package:nextrade/providers/portfolio_controller.dart';
class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String _selectedTimeframe = '1D';

  List<FlSpot> _spots = [];
  Timer? _timer;
  double _currentPrice = 0.0;
  double _minPrice = 0.0;
  double _maxPrice = 0.0;
  int _timeCounter = 0;
  final int _maxDataPoints = 60;
  double _startPrice = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments as Map? ?? {};
      _startPrice = (args['price'] as num?)?.toDouble() ?? 67452.00;
      _currentPrice = _startPrice;
      _minPrice = _currentPrice * 0.995;
      _maxPrice = _currentPrice * 1.005;

      final random = Random();
      double price = _currentPrice;
      for (int i = 0; i < _maxDataPoints; i++) {
        _spots.add(FlSpot(i.toDouble(), price));
        price = price + (random.nextDouble() - 0.5) * (_startPrice * 0.002);
        if (price > _maxPrice) _maxPrice = price;
        if (price < _minPrice) _minPrice = price;
        _timeCounter++;
      }

      setState(() {});

      _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
        if (!mounted) return;
        setState(() {
          final random = Random();
          double change = (random.nextDouble() - 0.5) * (_startPrice * 0.0025);
          
          // Add some trend sometimes
          if (random.nextDouble() > 0.8) {
            change *= 2.5; 
          }
          
          _currentPrice = _currentPrice + change;

          if (_currentPrice > _maxPrice) _maxPrice = _currentPrice;
          if (_currentPrice < _minPrice) _minPrice = _currentPrice;

          _spots.add(FlSpot(_timeCounter.toDouble(), _currentPrice));
          if (_spots.length > _maxDataPoints) {
            _spots.removeAt(0);
          }
          _timeCounter++;
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map? ?? {};
    final name = args['name'] as String? ?? 'Bitcoin';
    final symbol = args['symbol'] as String? ?? 'BTC';
    
    final initialChange = (args['change'] as num?)?.toDouble() ?? 2.45;
    final displayPrice = _currentPrice == 0.0 ? _startPrice : _currentPrice;
    
    // Calculate new change based on real-time price
    double currentChange = initialChange;
    if (_startPrice > 0) {
      currentChange = initialChange + ((displayPrice - _startPrice) / _startPrice * 100);
    }
    
    final isUp = currentChange >= 0;

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: Column(children: [
          Text(name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(symbol, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.star_border), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('\$${displayPrice.toStringAsFixed(displayPrice < 10 ? 4 : 2)}', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: (isUp ? AppTheme.accentGreen : AppTheme.errorRed).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                  child: Text('${isUp ? '+' : ''}${currentChange.toStringAsFixed(2)}%', style: GoogleFonts.inter(fontSize: 13, color: isUp ? AppTheme.accentGreen : AppTheme.errorRed, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                Text('${isUp ? '+' : ''}\$${(displayPrice * currentChange / 100).toStringAsFixed(displayPrice < 10 ? 4 : 2)} (24h)', style: GoogleFonts.inter(fontSize: 13, color: isUp ? AppTheme.accentGreen : AppTheme.errorRed)),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.only(right: 16, left: 0, top: 24, bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.glassBorder),
            ),
            child: _spots.isEmpty ? const Center(child: CircularProgressIndicator()) : LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (_maxPrice - _minPrice) <= 0 ? 1 : (_maxPrice - _minPrice) / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withValues(alpha: 0.05),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 56,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                          child: Text(
                            value.toStringAsFixed(displayPrice < 10 ? 4 : 2),
                            style: GoogleFonts.inter(
                              color: AppTheme.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: _spots.first.x,
                maxX: _spots.last.x,
                minY: _minPrice - (_minPrice * 0.001),
                maxY: _maxPrice + (_maxPrice * 0.001),
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots,
                    isCurved: true,
                    curveSmoothness: 0.2,
                    color: isUp ? AppTheme.accentGreen : AppTheme.errorRed,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) => spot.x == _spots.last.x,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: isUp ? AppTheme.accentGreen : AppTheme.errorRed,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          (isUp ? AppTheme.accentGreen : AppTheme.errorRed).withValues(alpha: 0.3),
                          (isUp ? AppTheme.accentGreen : AppTheme.errorRed).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppTheme.darkBg,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          '\$${touchedSpot.y.toStringAsFixed(displayPrice < 10 ? 4 : 2)}',
                          GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: ['1H', '4H', '1D', '1W', '1M', '1Y'].map((time) {
              final isSelected = _selectedTimeframe == time;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(time, style: const TextStyle(fontSize: 12)),
                  selected: isSelected, onSelected: (_) => setState(() => _selectedTimeframe = time),
                  selectedColor: AppTheme.primaryPurple.withValues(alpha: 0.3),
                  backgroundColor: AppTheme.glassBg,
                  labelStyle: TextStyle(color: isSelected ? AppTheme.primaryPurple : AppTheme.textSecondary),
                ),
              );
            }).toList()),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _showTradeSheet(context, 'buy', name, symbol, displayPrice, args['id'] as String?),
                    icon: const Icon(Icons.trending_up, size: 20),
                    label: const Text('Beli'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _showTradeSheet(context, 'sell', name, symbol, displayPrice, args['id'] as String?),
                    icon: const Icon(Icons.trending_down, size: 20),
                    label: const Text('Jual'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              _buildInfoChip(Icons.analytics_outlined, 'Analisis', () => Get.toNamed(RouteNames.aiAnalysis)),
              const SizedBox(width: 8),
              _buildInfoChip(Icons.history, 'Riwayat', () => Get.toNamed(RouteNames.history)),
              const SizedBox(width: 8),
              _buildInfoChip(Icons.info_outline, 'Info', () {}),
            ]),
          ),
        ],
      ),
    );
  }

  void _showTradeSheet(BuildContext context, String type, String name, String symbol, double price, String? marketId) {
    final isBuy = type == 'buy';
    final amountController = TextEditingController(text: '0');
    final formKey = GlobalKey<FormState>();

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            final amount = double.tryParse(amountController.text) ?? 0;
            final totalValue = amount * price;
            final auth = Get.find<AuthController>();
            final trading = Get.find<TradingController>();

            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Form(
                key: formKey,
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${isBuy ? 'Beli' : 'Jual'} $symbol', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (isBuy ? AppTheme.accentGreen : AppTheme.errorRed).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: (isBuy ? AppTheme.accentGreen : AppTheme.errorRed).withValues(alpha: 0.3)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(isBuy ? Icons.trending_up : Icons.trending_down, size: 16, color: isBuy ? AppTheme.accentGreen : AppTheme.errorRed),
                        const SizedBox(width: 4),
                        Text(isBuy ? 'Market Order' : 'Market Order', style: GoogleFonts.inter(fontSize: 11, color: isBuy ? AppTheme.accentGreen : AppTheme.errorRed, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          type = 'buy';
                          setSheetState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isBuy ? AppTheme.accentGreen.withValues(alpha: 0.2) : AppTheme.darkBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isBuy ? AppTheme.accentGreen : AppTheme.glassBorder),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.trending_up, size: 18, color: isBuy ? AppTheme.accentGreen : AppTheme.textSecondary),
                            const SizedBox(width: 6),
                            Text('Beli', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: isBuy ? AppTheme.accentGreen : AppTheme.textSecondary)),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          type = 'sell';
                          setSheetState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: !isBuy ? AppTheme.errorRed.withValues(alpha: 0.2) : AppTheme.darkBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: !isBuy ? AppTheme.errorRed : AppTheme.glassBorder),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.trending_down, size: 18, color: !isBuy ? AppTheme.errorRed : AppTheme.textSecondary),
                            const SizedBox(width: 6),
                            Text('Jual', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: !isBuy ? AppTheme.errorRed : AppTheme.textSecondary)),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Harga $symbol', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                    Text('\$${price.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Saldo Virtual', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                    Obx(() => Text('\$${(auth.user.value?.virtualBalance ?? 10000).toStringAsFixed(2)}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white))),
                  ]),
                  const SizedBox(height: 20),
                  Text('Jumlah', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    decoration: InputDecoration(suffixText: symbol, suffixStyle: GoogleFonts.inter(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                    onChanged: (_) => setSheetState(() {}),
                    validator: (v) {
                      final val = double.tryParse(v ?? '');
                      if (val == null || val <= 0) return 'Jumlah tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    _buildQuickAmount('+0.01', 0.01, amountController, setSheetState), const SizedBox(width: 8),
                    _buildQuickAmount('+0.1', 0.1, amountController, setSheetState), const SizedBox(width: 8),
                    _buildQuickAmount('+1.0', 1.0, amountController, setSheetState), const SizedBox(width: 8),
                    _buildMaxAmount(type, symbol, marketId, price, amountController, setSheetState),
                  ]),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppTheme.darkBg, borderRadius: BorderRadius.circular(12)),
                    child: Column(children: [
                      _buildOrderDetail('Harga', '\$${price.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _buildOrderDetail('Jumlah', '${amountController.text} $symbol'),
                      const Divider(height: 20),
                      _buildOrderDetail('Total', '\$${totalValue.toStringAsFixed(2)}', isBold: true),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Obx(() => SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton.icon(
                      onPressed: trading.isProcessing.value ? null : () => _executeTrade(context, type, symbol, name, price, marketId, amountController, formKey),
                      icon: trading.isProcessing.value
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Icon(isBuy ? Icons.trending_up : Icons.trending_down),
                      label: Text(trading.isProcessing.value ? 'Memproses...' : isBuy ? 'Konfirmasi Beli' : 'Konfirmasi Jual'),
                      style: ElevatedButton.styleFrom(backgroundColor: isBuy ? AppTheme.accentGreen : AppTheme.errorRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  )),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickAmount(String label, double amountToAdd, TextEditingController controller, void Function(void Function()) setState) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final current = double.tryParse(controller.text) ?? 0;
          final newVal = current + amountToAdd;
          final truncated = (newVal * 1000000).floorToDouble() / 1000000;
          controller.text = truncated.toString();
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: AppTheme.darkBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.glassBorder)),
          child: Text(label, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        ),
      ),
    );
  }

  Widget _buildMaxAmount(String type, String symbol, String? marketId, double price, TextEditingController controller, void Function(void Function()) setState) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final isBuy = type == 'buy';
          if (isBuy) {
            final auth = Get.find<AuthController>();
            final balance = auth.user.value?.virtualBalance ?? 0;
            final maxAmount = balance / price;
            // truncate rather than round up to avoid insufficient balance error
            final truncated = (maxAmount * 1000000).floorToDouble() / 1000000;
            controller.text = truncated.toString();
          } else {
            final portfolio = Get.find<PortfolioController>();
            final id = marketId ?? symbol.toLowerCase();
            final asset = portfolio.portfolioAssets.firstWhereOrNull((a) => a.marketId == id);
            final maxAmount = asset?.amount ?? 0;
            controller.text = maxAmount.toString();
          }
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withValues(alpha: 0.2), 
            borderRadius: BorderRadius.circular(8), 
            border: Border.all(color: AppTheme.primaryPurple)
          ),
          child: Text('MAX', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple)),
        ),
      ),
    );
  }

  Widget _buildOrderDetail(String label, String value, {bool isBold = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
      Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: Colors.white)),
    ]);
  }

  Future<void> _executeTrade(BuildContext context, String type, String symbol, String name, double price, String? marketId, TextEditingController amountController, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    final trading = Get.find<TradingController>();
    final amount = double.tryParse(amountController.text) ?? 0;
    final id = marketId ?? symbol.toLowerCase();

    Map<String, dynamic> result;
    if (type == 'buy') {
      result = await trading.executeBuy(marketId: id, symbol: symbol, name: name, amount: amount, price: price);
    } else {
      result = await trading.executeSell(marketId: id, symbol: symbol, name: name, amount: amount, price: price);
    }

    if (result['success'] == true) {
      Get.back();
      Get.snackbar('Berhasil', result['message'] as String, backgroundColor: AppTheme.accentGreen, colorText: Colors.white);
    } else {
      Get.snackbar('Gagal', result['message'] as String, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
    }
  }

  Widget _buildInfoChip(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            Icon(icon, size: 20, color: AppTheme.primaryPurple),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary)),
          ]),
        ),
      ),
    );
  }
}
