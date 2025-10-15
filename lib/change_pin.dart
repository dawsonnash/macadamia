import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'CodeShare/keyboard_actions.dart';
import 'CodeShare/variables.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  final _currentFocus = FocusNode();
  final _newFocus = FocusNode();
  final _confirmFocus = FocusNode();

  String _error = '';

  Future<void> _changePin() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString('lock_pin');

    if (_currentPinController.text != storedPin) {
      setState(() => _error = 'Incorrect current PIN');
      return;
    }

    if (_newPinController.text.length < 4) {
      setState(() => _error = 'New PIN must be at least 4 digits');
      return;
    }

    if (_newPinController.text != _confirmPinController.text) {
      setState(() => _error = 'New PINs do not match');
      return;
    }

    await prefs.setString('lock_pin', _newPinController.text);
    Navigator.pop(context); // Go back after successful change
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'PIN changed successfully',
          style: TextStyle(
            fontSize: AppData.text18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Change PIN', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.appBarColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: KeyboardActions(
          config: keyboardActionsConfig(
            focusNodes: [_currentFocus, _newFocus, _confirmFocus],
          ),
          disableScroll: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppData.sizedBox22),

              _buildPinField(_currentPinController, _currentFocus, 'Current PIN'),
              SizedBox(height: 16),
              _buildPinField(_newPinController, _newFocus, 'New PIN'),
              SizedBox(height: 16),
              _buildPinField(_confirmPinController, _confirmFocus, 'Confirm New PIN'),

              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(_error, style: TextStyle(color: Colors.red, fontSize: AppData.text18)),
                ),

              SizedBox(height: AppData.sizedBox22),
              ElevatedButton(
                onPressed: _changePin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Change PIN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppData.text18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinField(TextEditingController controller, FocusNode focusNode, String hint) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      obscureText: true,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      style: TextStyle(color: Colors.white, fontSize: AppData.text18),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54, fontSize: AppData.text18),
        filled: true,
        fillColor: Colors.grey[900],
        border: const OutlineInputBorder(),
      ),
    );
  }
}
