# Market Coverage & Asset Management

NexTrade menyediakan berbagai jenis market menggunakan data market asli untuk memberikan pengalaman simulasi trading yang realistis bagi pengguna. Tujuan fitur ini adalah menjelaskan bahwa NexTrade tidak hanya menyediakan beberapa asset, tetapi memiliki cakupan market yang luas layaknya aplikasi trading modern sungguhan.

---

## Supported Markets

### Cryptocurrency
* Menggunakan Binance API sebagai sumber data utama
* Mendukung minimal 300 hingga 500+ crypto assets
* Data market bersifat realtime menggunakan WebSocket
* Contoh asset: BTC, ETH, SOL, XRP, ADA, DOGE, BNB, AVAX, LINK, SUI

### Forex
* Mendukung minimal 20–30 pasangan mata uang
* Contoh: EUR/USD, GBP/USD, USD/JPY, AUD/USD, USD/CAD, NZD/USD

### Stocks
* Fokus pada saham populer Indonesia
* Mendukung minimal 50 saham Indonesia
* Contoh: BBCA, BBRI, BMRI, TLKM, ASII, GOTO, ICBP, INDF

### Gold & Commodities
* XAU/USD (Gold)
* XAG/USD (Silver)
* Kemungkinan pengembangan untuk Oil dan Natural Gas

---

## Market Categories

Market dikelompokkan menjadi:
* Favorites
* Crypto
* Forex
* Stocks
* Commodities
* Top Gainers
* Top Losers
* Trending

---

## Search System

User dapat mencari asset berdasarkan:
* Nama asset
* Symbol
* Kategori market

---

## Watchlist

User dapat:
* Menambahkan asset ke watchlist
* Menghapus asset dari watchlist
* Melihat update harga realtime

---

## Market Ranking

Sistem menampilkan:
* Top Gainers
* Top Losers
* Most Traded
* Trending Assets

---

## Realtime Market System

* Harga market diperbarui secara realtime menggunakan WebSocket
* Chart diperbarui secara realtime
* Watchlist diperbarui secara realtime
* Portfolio diperbarui secara realtime
* Profit/Loss diperbarui secara realtime

---

## Technical Requirement

* Market data tidak disimpan seluruhnya di Firebase
* Data market diambil langsung dari provider market
* Firebase hanya digunakan untuk user data, watchlist, portfolio, leaderboard, settings, dan AI history

---

## Scalability

Struktur market dirancang agar dapat mendukung:
* 500+ crypto assets
* 30+ forex pairs
* 50+ Indonesian stocks
* Gold & commodities
tanpa perlu perubahan besar pada arsitektur aplikasi.
