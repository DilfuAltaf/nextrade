import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _subtextFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _subtextFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
    _checkAuth();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkAuth() async {
    // Wait slightly longer so the user can enjoy the full animation
    await Future.delayed(const Duration(milliseconds: 2500));
    final auth = Get.find<AuthController>();
    if (auth.isAuthenticated.value) {
      Get.offNamed(RouteNames.home);
    } else {
      Get.offNamed(RouteNames.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryPurple, AppTheme.accentGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPurple.withValues(alpha: 0.4 * _logoScaleAnimation.value),
                          blurRadius: 40,
                          spreadRadius: 10 * _logoScaleAnimation.value,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'N', 
                        style: TextStyle(
                          fontSize: 56, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white
                        )
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Opacity(
                  opacity: _textFadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - _textFadeAnimation.value)),
                    child: Text(
                      'NexTrade',
                      style: GoogleFonts.poppins(
                        fontSize: 36, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white, 
                        letterSpacing: 2
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Opacity(
                  opacity: _subtextFadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _subtextFadeAnimation.value)),
                    child: Text(
                      'Trade Smarter, Grow Faster.',
                      style: GoogleFonts.inter(
                        fontSize: 16, 
                        color: AppTheme.textSecondary, 
                        fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
