import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_ostad/ui/utility/apps_color.dart';
import 'package:task_manager_ostad/ui/widget/background_widget.dart';
import 'package:task_manager_ostad/data/models/network_response.dart';
import 'package:task_manager_ostad/data/network_caller/network_caller.dart';
import 'package:task_manager_ostad/ui/widget/snackbar_message.dart';
import '../../../data/utilities/urls.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  bool _isProcessing = false;

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
                    "Set Password",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Minimum length password 8 characters with letter & number combination",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Confirm Password",
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _onTapConfirmButton,
                    child: _isProcessing
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("Confirm"),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.8)),
                              text: "Have an account?",
                              children: [
                                TextSpan(
                                  style: const TextStyle(
                                      color: AppsColor.themeColor),
                                  text: " Sign In",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _onTapSignInButton,
                                ),
                              ]),
                        ),
                      ],
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

  Future<void> _onTapConfirmButton() async {
    if (_passwordTEController.text != _confirmPasswordTEController.text) {
      showSnackBarMessage(context, "Passwords do not match.");
      return;
    }

    if (_passwordTEController.text.length < 8) {
      showSnackBarMessage(context, "Password must be at least 8 characters long.");
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    NetworkResponse response = await NetworkCaller.postRequest(
      Urls.recoverResetPass,
      body: {
        'email': widget.email,
        'password': _passwordTEController.text,
      },
    );

    if (response.isSuccess) {
      if (response.responseData['status'] == 'success') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false,
        );
      } else {
        if(mounted){
          showSnackBarMessage(context, response.responseData['message'] ?? 'Password reset failed, try again later.');
        }
      }
    } else {
      if(mounted){
        showSnackBarMessage(context, 'Password reset failed, try again later.');
      }
    }

    setState(() {
      _isProcessing = false;
    });
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false);
  }

  @override
  void dispose() {
    _confirmPasswordTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
