import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CodeShare/keyboard_actions.dart';
import 'CodeShare/variables.dart';

class IPSettingsScreen extends StatefulWidget {
  const IPSettingsScreen({super.key});

  @override
  State<IPSettingsScreen> createState() => _IPSettingsScreenState();
}

class _IPSettingsScreenState extends State<IPSettingsScreen> {
  final TextEditingController _ipController = TextEditingController();
  final FocusNode _ipFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadSavedIP();
  }

  Future<void> _loadSavedIP() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIP = prefs.getString('laptop_ip') ?? '';
    setState(() {
      _ipController.text = savedIP;
    });
  }

  Future<void> _saveIP() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('laptop_ip', _ipController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'IP Address Saved',
          style: TextStyle(
            fontSize: AppData.text18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating, // optional for better visibility
        duration: Duration(seconds: 2),      // optional for timing
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.95),
      body: Padding(
        padding: EdgeInsets.all(AppData.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Host IP Address',
              style: TextStyle(
                color: AppColors.textColorPrimary,
                fontSize: AppData.text22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppData.sizedBox8),
            KeyboardActions(
              config: keyboardActionsConfig(
                focusNodes: [_ipFocus],
              ),
              disableScroll: true,
              child: TextField(
                focusNode: _ipFocus,
                controller: _ipController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'e.g. 192.168.0.23',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: AppColors.textFieldColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderPrimary, width: 2.0),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                style: TextStyle(
                  color: AppColors.textColorPrimary,
                  fontSize: AppData.text24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: AppData.padding16),
            Center(
              child: ElevatedButton(
                onPressed: _saveIP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppData.padding20,
                    vertical: AppData.padding12,
                  ),
                  textStyle: TextStyle(
                    fontSize: AppData.text24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Save IP', style: TextStyle(color: Colors.black),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
