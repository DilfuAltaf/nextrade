# 21. Realtime Market System

## Overview
NexTrade menggunakan sistem realtime market untuk menampilkan harga market secara live tanpa perlu refresh manual.

Sistem realtime ini digunakan untuk:
- Live market price
- Live chart update
- Portfolio realtime
- Profit/Loss realtime
- Watchlist realtime
- Trading simulation realtime

---

## Realtime Technologies

### WebSocket
NexTrade menggunakan WebSocket untuk menerima data market secara realtime dari server market provider.

Keuntungan:
- Low latency
- Realtime update
- Efisien dibanding polling API
- Cocok untuk aplikasi trading

---

## Market Data Providers

### Main Provider
- Binance WebSocket API

### Additional Providers
- TradingView
- Custom Firebase Backend

---

# 22. Realtime Data Flow

```text
Binance WebSocket
        ↓
Market Service
        ↓
Provider State Management
        ↓
Realtime UI Update
        ↓
Chart & Portfolio Update
```

---

# 23. Realtime Features

## Live Market Prices
Harga market berubah secara realtime:
- BTC
- ETH
- Forex
- Gold
- Stocks

## Live Portfolio Tracking
Portfolio user otomatis berubah mengikuti harga market terbaru.

## Realtime Profit & Loss
Profit dan loss dihitung otomatis berdasarkan perubahan market.

## Realtime Watchlist
Watchlist akan memperbarui harga asset secara live.

## Live Trading Charts
Chart trading berubah secara realtime menggunakan candlestick data.

---

# 24. Chart System

## Chart Type
- Candlestick Chart
- Line Chart
- Market Depth Visualization

## Chart Provider
### Primary
- TradingView Lightweight Charts

### Alternative
- fl_chart
- Syncfusion Flutter Charts

## Chart Features
- Zoom
- Pan
- Candle analysis
- Timeframe selection
- Technical indicators

---

# 25. Firebase Realtime Usage

## Firebase Responsibilities
Firebase digunakan untuk:
- Authentication
- User data
- Portfolio storage
- Watchlist storage
- Leaderboard
- User preferences
- AI chat history

## Firestore Collections
```text
users/
portfolio/
watchlist/
transactions/
leaderboard/
market_cache/
ai_history/
```

---

# 26. Market Service Architecture

## Market Service Responsibilities
- Connect to Binance WebSocket
- Parse realtime market data
- Update Provider state
- Handle reconnection
- Cache market data

## Example Architecture
```text
WebSocket
    ↓
Market Service
    ↓
Market Provider
    ↓
UI Screens
```

---

# 27. Provider State Management

## Market Provider
Digunakan untuk:
- Current market prices
- Selected asset
- Chart data
- Trading states

## Portfolio Provider
Digunakan untuk:
- User assets
- Profit/Loss
- Balance calculation

## Theme Provider
Digunakan untuk:
- Dark mode
- Light mode

## Auth Provider
Digunakan untuk:
- Login state
- User session
- Authentication management

---

# 28. Realtime Performance Optimization

## Optimization Methods
- Stream-based update
- Lazy loading
- Cached market data
- Efficient state update
- Background websocket reconnect

## Goals
- Smooth realtime UI
- Low memory usage
- Fast chart rendering
- Stable websocket connection

---

# 29. Recommended Flutter Packages

## Core Packages
```yaml
provider:
go_router:
firebase_core:
firebase_auth:
cloud_firestore:
firebase_database:
google_sign_in:
```

## Realtime & API Packages
```yaml
web_socket_channel:
dio:
http:
```

## Chart Packages
```yaml
fl_chart:
syncfusion_flutter_charts:
```

## Local Storage
```yaml
shared_preferences:
```

---

# 30. Future Realtime Improvements

## Planned Features
- Multi-chart support
- Advanced technical indicators
- Realtime AI prediction
- Smart signal notification
- Advanced market analytics
- Live copy trading simulation