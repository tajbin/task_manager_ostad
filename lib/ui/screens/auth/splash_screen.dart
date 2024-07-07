import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_ostad/ui/controllers/auth_controller.dart';
import 'package:task_manager_ostad/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_ostad/ui/screens/main_bottom_nav_bar.dart';
import 'package:task_manager_ostad/ui/utility/asset_paths.dart';
import 'package:task_manager_ostad/ui/widget/background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1));

    bool isUSerLoggedIn = await AuthController.checkAuthState();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isUSerLoggedIn
                  ? const MainBottomNavBar()
                  : const SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
      child: Center(
        child: SvgPicture.asset(
          AssetPaths.logoSvg,
          width: 140,
        ),
      ),
    ));
  }
}
