import 'package:get/get.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/pages/splash/splash_page.dart';
import 'package:nextrade/pages/auth/login_page.dart';
import 'package:nextrade/pages/auth/register_page.dart';
import 'package:nextrade/pages/auth/forgot_password_page.dart';
import 'package:nextrade/pages/education/onboarding_page.dart';
import 'package:nextrade/pages/home/home_page.dart';
import 'package:nextrade/pages/market/market_page.dart';
import 'package:nextrade/pages/market/chart_page.dart';
import 'package:nextrade/pages/trading/trading_page.dart';
import 'package:nextrade/pages/portfolio/portfolio_page.dart';
import 'package:nextrade/pages/watchlist/watchlist_page.dart';
import 'package:nextrade/pages/history/history_page.dart';
import 'package:nextrade/pages/ai/ai_assistant_page.dart';
import 'package:nextrade/pages/ai/ai_chatbot_page.dart';
import 'package:nextrade/pages/ai/ai_analysis_page.dart';
import 'package:nextrade/pages/ai/ai_candle_analysis_page.dart';
import 'package:nextrade/pages/ai/ai_recommendation_page.dart';
import 'package:nextrade/pages/social/leaderboard_page.dart';
import 'package:nextrade/pages/social/community_page.dart';
import 'package:nextrade/pages/social/trader_profile_page.dart';
import 'package:nextrade/pages/education/academy_page.dart';
import 'package:nextrade/pages/profile/profile_page.dart';
import 'package:nextrade/pages/settings/settings_page.dart';
import 'package:nextrade/pages/settings/security_page.dart';
import 'package:nextrade/pages/notifications/notification_page.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: RouteNames.splash, page: () => const SplashPage()),
    GetPage(name: RouteNames.onboarding, page: () => const OnboardingPage()),
    GetPage(name: RouteNames.login, page: () => const LoginPage()),
    GetPage(name: RouteNames.register, page: () => const RegisterPage()),
    GetPage(name: RouteNames.forgotPassword, page: () => const ForgotPasswordPage()),
    GetPage(name: RouteNames.home, page: () => const HomePage()),
    GetPage(name: RouteNames.market, page: () => const MarketPage()),
    GetPage(name: RouteNames.chart, page: () => const ChartPage()),
    GetPage(name: RouteNames.trading, page: () => const TradingPage()),
    GetPage(name: RouteNames.portfolio, page: () => const PortfolioPage()),
    GetPage(name: RouteNames.watchlist, page: () => const WatchlistPage()),
    GetPage(name: RouteNames.history, page: () => const HistoryPage()),
    GetPage(name: RouteNames.aiAssistant, page: () => const AiAssistantPage()),
    GetPage(name: RouteNames.aiChatbot, page: () => const AiChatbotPage()),
    GetPage(name: RouteNames.aiAnalysis, page: () => const AiAnalysisPage()),
    GetPage(name: RouteNames.aiCandleAnalysis, page: () => const AiCandleAnalysisPage()),
    GetPage(name: RouteNames.aiRecommendation, page: () => const AiRecommendationPage()),
    GetPage(name: RouteNames.leaderboard, page: () => const LeaderboardPage()),
    GetPage(name: RouteNames.community, page: () => const CommunityPage()),
    GetPage(name: RouteNames.traderProfile, page: () => const TraderProfilePage()),
    GetPage(name: RouteNames.academy, page: () => const AcademyPage()),
    GetPage(name: RouteNames.profile, page: () => const ProfilePage()),
    GetPage(name: RouteNames.settings, page: () => const SettingsPage()),
    GetPage(name: RouteNames.security, page: () => const SecurityPage()),
    GetPage(name: RouteNames.notifications, page: () => const NotificationPage()),
  ];
}
