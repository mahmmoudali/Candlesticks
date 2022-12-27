import 'dart:developer';

import 'package:candlestick_chart/ui/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    checkBiometrics();
    super.initState();
  }

  void checkBiometrics() async {
    await _authenticateWithBiometrics();
    if (_authorized == 'Authorized') {
      {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    }
  }

  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please Provide your fingeprint to continue",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                checkBiometrics();
              },
              child: const Icon(
                Icons.fingerprint,
                color: Colors.blue,
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      _authorized = 'Authenticating';
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      _authorized = 'Authenticating';
    } on PlatformException catch (e) {
      log(e.toString());
      _authorized = 'Error - ${e.message}';
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    _authorized = message;
  }
}
