import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nextrade/app/routes/app_routes.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/firebase_options.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/providers/market_controller.dart';
import 'package:nextrade/providers/portfolio_controller.dart';
import 'package:nextrade/providers/trading_controller.dart';
import 'package:nextrade/providers/notification_controller.dart';
import 'package:nextrade/providers/social_controller.dart';
import 'package:nextrade/providers/ai_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const NexTradeApp());
}

class NexTradeApp extends StatelessWidget {
  const NexTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NexTrade',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      defaultTransition: Transition.fadeIn,
      initialRoute: RouteNames.splash,
      getPages: AppRoutes.pages,
      initialBinding: AppBinding(),
    );
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(MarketController(), permanent: true);
    Get.put(PortfolioController(), permanent: true);
    Get.put(TradingController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(SocialController(), permanent: true);
    Get.put(AiController(), permanent: true);
  }
}
