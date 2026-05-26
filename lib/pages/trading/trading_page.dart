import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/providers/trading_controller.dart';

class TradingPage extends StatefulWidget {
  const TradingPage({super.key});

  @override
  State<TradingPage> createState() => _TradingPageState();
}

class _TradingPageState extends State<TradingPage> {
  final args = Get.arguments as Map? ?? {};
  late String type;
  late String symbol;
  late String name;
  late double price;
  late String marketId;
  final amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    type = args['type'] as String? ?? 'buy';
    symbol = args['symbol'] as String? ?? 'BTC';
    name = args['name'] as String? ?? 'Bitcoin';
    price = (args['price'] as num?)?.toDouble() ?? 67452.00;
    marketId = args['marketId'] as String? ?? symbol.toLowerCase();
    amountController.text = '0.001';
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBuy = type == 'buy';
    final amount = double.tryParse(amountController.text) ?? 0;
    final totalValue = amount * price;
    final auth = Get.find<AuthController>();
    final trading = Get.find<TradingController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('${isBuy ? 'Beli' : 'Jual'} $symbol', style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Harga $symbol', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                      Text('\$${price.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  )),
                  const SizedBox(height: 20),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Saldo Virtual', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                      Text('\$${(auth.user.value?.virtualBalance ?? 10000).toStringAsFixed(2)}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  )),
                ]),
              ),
              const SizedBox(height: 24),
              Text('Jumlah', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              const SizedBox(height: 8),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                decoration: InputDecoration(suffixText: symbol, suffixStyle: GoogleFonts.inter(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  final val = double.tryParse(v ?? '');
                  if (val == null || val <= 0) return 'Jumlah tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(children: [
                _buildQuickAmount('0.001'), const SizedBox(width: 8),
                _buildQuickAmount('0.01'), const SizedBox(width: 8),
                _buildQuickAmount('0.1'), const SizedBox(width: 8),
                _buildQuickAmount('1'),
              ]),
              const SizedBox(height: 24),
              Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
                child: Column(children: [
                  _buildOrderDetail('Tipe Order', 'Market Order'),
                  const SizedBox(height: 12),
                  _buildOrderDetail('Harga', '\$${price.toStringAsFixed(2)}'),
                  const SizedBox(height: 12),
                  _buildOrderDetail('Jumlah', '${amountController.text} $symbol'),
                  const Divider(height: 24),
                  _buildOrderDetail('Total', '\$${totalValue.toStringAsFixed(2)}', isBold: true),
                ]),
              ),
              const SizedBox(height: 24),
              Obx(() => SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton.icon(
                  onPressed: trading.isProcessing.value ? null : _executeTrade,
                  icon: trading.isProcessing.value
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Icon(isBuy ? Icons.trending_up : Icons.trending_down),
                  label: Text(trading.isProcessing.value ? 'Memproses...' : isBuy ? 'Konfirmasi Beli' : 'Konfirmasi Jual'),
                  style: ElevatedButton.styleFrom(backgroundColor: isBuy ? AppTheme.accentGreen : AppTheme.errorRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              )),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton.icon(onPressed: () => _showLimitOrderDialog(context), icon: const Icon(Icons.notifications_outlined, size: 18), label: const Text('Buat Limit Order')),
                TextButton.icon(onPressed: () => _showStopLossDialog(context), icon: const Icon(Icons.shield_outlined, size: 18), label: const Text('Stop Loss')),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAmount(String amount) {
    return Expanded(
      child: GestureDetector(
        onTap: () { amountController.text = amount; setState(() {}); },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.glassBorder)),
          child: Text(amount, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
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

  Future<void> _executeTrade() async {
    if (!formKey.currentState!.validate()) return;
    final trading = Get.find<TradingController>();
    final amount = double.tryParse(amountController.text) ?? 0;

    Map<String, dynamic> result;
    if (type == 'buy') {
      result = await trading.executeBuy(marketId: marketId, symbol: symbol, name: name, amount: amount, price: price);
    } else {
      result = await trading.executeSell(marketId: marketId, symbol: symbol, name: name, amount: amount, price: price);
    }

    if (result['success'] == true) {
      Get.snackbar('Berhasil', result['message'] as String, backgroundColor: AppTheme.accentGreen, colorText: Colors.white);
      Get.back();
    } else {
      Get.snackbar('Gagal', result['message'] as String, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
    }
  }

  void _showLimitOrderDialog(BuildContext context) {
    final priceController = TextEditingController(text: price.toStringAsFixed(2));
    final amountCtrl = TextEditingController(text: '0.001');

    Get.dialog(Dialog(
      backgroundColor: AppTheme.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Limit Order', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Text('Harga Limit', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          TextField(controller: priceController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(prefixText: '\$ ')),
          const SizedBox(height: 16),
          Text('Jumlah $symbol', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          TextField(controller: amountCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.find<TradingController>().createLimitOrder(
                  marketId: marketId, symbol: symbol, name: name,
                  type: type, orderType: 'limit',
                  amount: double.tryParse(amountCtrl.text) ?? 0,
                  price: double.tryParse(priceController.text) ?? price,
                );
                Get.back();
              },
              child: Text('Buat ${type == 'buy' ? 'Beli' : 'Jual'} Limit'),
            ),
          ),
        ]),
      ),
    ));
  }

  void _showStopLossDialog(BuildContext context) {
    final priceController = TextEditingController(text: (price * 0.95).toStringAsFixed(2));
    final amountCtrl = TextEditingController(text: '0.001');

    Get.dialog(Dialog(
      backgroundColor: AppTheme.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Stop Loss', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Text('Harga Trigger', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          TextField(controller: priceController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(prefixText: '\$ ')),
          const SizedBox(height: 16),
          Text('Jumlah $symbol', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          TextField(controller: amountCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.find<TradingController>().createLimitOrder(
                  marketId: marketId, symbol: symbol, name: name,
                  type: 'sell', orderType: 'stop_loss',
                  amount: double.tryParse(amountCtrl.text) ?? 0,
                  price: double.tryParse(priceController.text) ?? price,
                  triggerPrice: double.tryParse(priceController.text) ?? price,
                );
                Get.back();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
              child: const Text('Buat Stop Loss'),
            ),
          ),
        ]),
      ),
    ));
  }
}
