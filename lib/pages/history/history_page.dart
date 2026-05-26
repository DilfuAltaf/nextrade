import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/trading_controller.dart';
import 'package:nextrade/models/transaction_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final trading = Get.find<TradingController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('Riwayat Transaksi', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: Obx(() {
        final txList = _filter == 'Semua'
            ? trading.transactions
            : trading.transactions.where((t) => t.type == _filter.toLowerCase()).toList();

        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(children: [
              Expanded(child: ChoiceChip(label: const Text('Semua'), selected: _filter == 'Semua', onSelected: (_) => setState(() => _filter = 'Semua'))),
              const SizedBox(width: 8),
              Expanded(child: ChoiceChip(label: const Text('Beli'), selected: _filter == 'buy', onSelected: (_) => setState(() => _filter = 'buy'))),
              const SizedBox(width: 8),
              Expanded(child: ChoiceChip(label: const Text('Jual'), selected: _filter == 'sell', onSelected: (_) => setState(() => _filter = 'sell'))),
            ]),
          ),
          Expanded(
            child: trading.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : txList.isEmpty
                    ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.receipt_long_outlined, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text('Belum ada transaksi', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                      ]))
                    : RefreshIndicator(
                        onRefresh: () => trading.loadData(),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: txList.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) => _buildHistoryItem(txList[index]),
                        ),
                      ),
          ),
        ]);
      }),
    );
  }

  Widget _buildHistoryItem(TransactionModel tx) {
    final isBuy = tx.type == 'buy';
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(shape: BoxShape.circle, color: (isBuy ? AppTheme.accentGreen : AppTheme.errorRed).withValues(alpha: 0.2)),
          child: Icon(isBuy ? Icons.arrow_downward : Icons.arrow_upward, color: isBuy ? AppTheme.accentGreen : AppTheme.errorRed, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(isBuy ? 'Beli' : 'Jual', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(width: 8),
            Text(tx.symbol, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
          ]),
          Text('${tx.amount} ${tx.symbol} @ \$${tx.price.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('\$${tx.total.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          Text(dateFormat.format(tx.createdAt), style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary.withValues(alpha: 0.7))),
        ]),
      ]),
    );
  }
}
