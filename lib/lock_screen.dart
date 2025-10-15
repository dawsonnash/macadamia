import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CodeShare/keyboard_actions.dart';
import 'CodeShare/variables.dart';

class LockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;
  const LockScreen({super.key, required this.onUnlocked});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String _error = '';
  bool _isSettingPin = false;

  final FocusNode _codeFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _checkIfPinExists();
  }

  Future<void> _checkIfPinExists() async {
    final prefs = await SharedPreferences.getInstance();
    final existingPin = prefs.getString('lock_pin');
    setState(() {
      _isSettingPin = existingPin == null;
    });
  }

  Future<void> _verifyCode() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString('lock_pin');

    if (_codeController.text == storedPin) {
      widget.onUnlocked();
    } else {
      setState(() {
        _error = 'Incorrect code';
      });
    }
  }

  Future<void> _setPin() async {
    if (_codeController.text.length < 4) {
      setState(() {
        _error = 'PIN must be at least 4 digits';
      });
      return;
    }

    if (_codeController.text != _confirmController.text) {
      setState(() {
        _error = 'PINs do not match';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lock_pin', _codeController.text);
    widget.onUnlocked();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: AppData.text64, color: Colors.white),
               SizedBox(height: AppData.sizedBox22),
              KeyboardActions(
                config: keyboardActionsConfig(
                  focusNodes: [_codeFocus],
                ),
                disableScroll: true,
                child: TextField(
                  focusNode: _codeFocus,
                  controller: _codeController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],

                  style: TextStyle(color: Colors.white, fontSize: AppData.text22),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: _isSettingPin ? 'Set PIN' : 'Enter PIN',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: AppData.text22),
                    errorText: _error.isEmpty ? null : _error,
                    errorStyle: TextStyle(fontSize: AppData.text18),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              if (_isSettingPin) ...[
                const SizedBox(height: 16),
                KeyboardActions(
                  config: keyboardActionsConfig(
                    focusNodes: [_confirmFocus],
                  ),
                  disableScroll: true,
                  child: TextField(
                    focusNode: _confirmFocus,
                    controller: _confirmController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],

                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Confirm PIN',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
              SizedBox(height: AppData.sizedBox22),
              ElevatedButton(
                onPressed: _isSettingPin ? _setPin : _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // background color
                  foregroundColor: Colors.black, // text (and icon) color
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  _isSettingPin ? 'Set PIN' : 'Unlock',
                  style:  TextStyle(fontWeight: FontWeight.bold, fontSize: AppData.text16),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
