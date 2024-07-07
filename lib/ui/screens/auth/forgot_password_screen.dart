import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/screens/auth/pin_verfication_screen.dart';
import 'package:task_manager_ostad/ui/widget/background_widget.dart';

import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
import '../../utility/apps_color.dart';
import '../../widget/snackbar_message.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _verifyEmailInProgress = false;
  final TextEditingController _emailTEController = TextEditingController();

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
                    "Your Email Address",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "A 6 digit verification pin will be sent to your email address",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _verifyEmailInProgress ? null : _onTapNextButton,
                    child: _verifyEmailInProgress
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.arrow_circle_right_outlined),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.8),
                        ),
                        text: "Have an account?",
                        children: [
                          TextSpan(
                            style: const TextStyle(color: AppsColor.themeColor),
                            text: " Sign In",
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignInButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapNextButton() {
    _verifyEmail();
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    setState(() {
      _verifyEmailInProgress = true;
    });

    String email = _emailTEController.text.trim();
    NetworkResponse response = await NetworkCaller.getRequest(
      '${Urls.recoverVerifyEmail}?email=$email',
    );

    if (response.isSuccess) {
      print('Response Data: ${response.responseData}');
      if (response.responseData['status'] == 'success') {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PinVerificationScreen(email: email),
            ),
          );
        }
      } else {
        if (mounted) {
          showSnackBarMessage(
              context,
              response.responseData['message'] ?? 'Email verification failed, try again later.'
          );
        }
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
            context,
            'Email verification failed, try again later. (Error: ${response.errorMessage})'
        );
      }
    }

    setState(() {
      _verifyEmailInProgress = false;
    });
  }
}
