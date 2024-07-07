import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_ostad/ui/screens/auth/set_password_screen.dart';
import 'package:task_manager_ostad/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_ostad/ui/utility/apps_color.dart';
import 'package:task_manager_ostad/ui/widget/background_widget.dart';
import 'package:task_manager_ostad/data/models/network_response.dart';
import 'package:task_manager_ostad/data/network_caller/network_caller.dart';
import 'package:task_manager_ostad/ui/widget/snackbar_message.dart';
import '../../../data/utilities/urls.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});
  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
  bool _isVerifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundWidget(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Pin Verification",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "A 6 digit verification pin has been sent to your email address",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildPinCodeTextField(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onTapNextButton,
                    child: _isVerifying
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("Verify"),
                  ),
                  const SizedBox(height: 32),
                  _buildBackToSignIn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center _buildBackToSignIn() {
    return Center(
      child: RichText(
        text: TextSpan(
            style:
            TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.8)),
            text: "Have an account?",
            children: [
              TextSpan(
                style: const TextStyle(color: AppsColor.themeColor),
                text: " Sign In",
                recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
              ),
            ]),
      ),
    );
  }

  PinCodeTextField _buildPinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        selectedFillColor: AppsColor.white,
        inactiveFillColor: AppsColor.white,
        selectedColor: AppsColor.themeColor,
      ),
      keyboardType: TextInputType.number,
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _pinTEController,
      appContext: context,
    );
  }

  void _onTapNextButton() {
    _verifyOTP();
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
          (route) => false,
    );
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isVerifying = true;
    });

    String otp = _pinTEController.text.trim();
    String email = widget.email;

    NetworkResponse response = await NetworkCaller.getRequest(
      '${Urls.recoverVerifyOTP}?email=$email&otp=$otp',
    );

    if (response.isSuccess) {
      if (response.responseData['status'] == 'success') {
        if(mounted){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetPasswordScreen(email: email),
            ),
          );
        }
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            response.responseData['message'] ?? 'OTP verification failed, try again later.',
          );
        }
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'OTP verification failed, try again later.');
      }
    }

    setState(() {
      _isVerifying = false;
    });
  }

  @override
  void dispose() {
    _pinTEController.dispose();
    super.dispose();
  }
}
