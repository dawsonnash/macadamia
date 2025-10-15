import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../generate_password.dart';
import 'Algorithms/passwordGenerator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'CodeShare/clipboard_helper.dart';
import 'CodeShare/keyboard_actions.dart';
import 'CodeShare/variables.dart';

class GeneratePasswordScreen extends StatefulWidget {
  const GeneratePasswordScreen({super.key});

  @override
  State<GeneratePasswordScreen> createState() => _GeneratePasswordScreenState();
}

class _GeneratePasswordScreenState extends State<GeneratePasswordScreen> {
  final _baseController = TextEditingController();
  final _siteController = TextEditingController();
  final _versionController = TextEditingController(text: '1');
  final _lengthController = TextEditingController(text: '16');

  String _charRule = 'full';
  String _generatedPassword = '';

  final FocusNode _versionFocusNode = FocusNode();
  final FocusNode _lengthFocusNode = FocusNode();

  void _generate() {
    final base = _baseController.text.trim();
    final site = _siteController.text.trim();
    final version = _versionController.text.trim();
    final length = int.tryParse(_lengthController.text.trim()) ?? 16;

    if (base.isEmpty || site.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Base password and site key are required',
            style: TextStyle(
              fontSize: AppData.text18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // optional for better visibility
          duration: Duration(seconds: 2),      // optional for timing
        ),
      );
      return;
    }
    if (version.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Version number is required',
            style: TextStyle(
              fontSize: AppData.text18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // optional for better visibility
          duration: Duration(seconds: 2),      // optional for timing
        ),
      );
      return;
    }
    if (_lengthController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Length is required',
            style: TextStyle(
              fontSize: AppData.text18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // optional for better visibility
          duration: Duration(seconds: 2),      // optional for timing
        ),
      );
      return;
    }

    final password = generatePassword(
      basePassword: base,
      siteKey: site,
      version: version,
      length: length,
      charRule: _charRule,
    );

    setState(() {
      _generatedPassword = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black.withValues(alpha: 0.95)
          ),
          Padding(
            padding: EdgeInsets.only(top: AppData.padding16),
            child: ListView(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: AppData.padding16, right: AppData.padding16),
                    child: Container(
                      width: AppData.inputFieldWidth,
                      child: TextField(
                        controller: _baseController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Enter Base Password',
                          labelStyle: TextStyle(
                            color: AppColors.textColorPrimary, // Label color when not focused
                            fontSize: AppData.text22, // Label font size
                          ),
                          filled: true,
                          fillColor: AppColors.textFieldColor,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.borderPrimary,
                              // Border color when the TextField is not focused
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(4.0), // Rounded corners
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              // Border color when the TextField is focused
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        style: TextStyle(
                          color: AppColors.textColorPrimary,
                          fontSize: AppData.text24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),

                SizedBox(height: AppData.spacingStandard),

                Padding(
                    padding: EdgeInsets.only(left: AppData.padding16, right: AppData.padding16),
                    child: Container(
                      width: AppData.inputFieldWidth,
                      child: TextField(
                        controller: _siteController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Enter Site Key',
                          labelStyle: TextStyle(
                            color: AppColors.textColorPrimary, // Label color when not focused
                            fontSize: AppData.text22, // Label font size
                          ),
                          filled: true,
                          fillColor: AppColors.textFieldColor,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.borderPrimary,
                              // Border color when the TextField is not focused
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(4.0), // Rounded corners
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              // Border color when the TextField is focused
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        style: TextStyle(
                          color: AppColors.textColorPrimary,
                          fontSize: AppData.text24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),

                SizedBox(height: AppData.spacingStandard),

                Padding(
                    padding: EdgeInsets.only(left: AppData.padding16, right: AppData.padding16),
                    child: Container(
                      width: AppData.inputFieldWidth,
                      child: KeyboardActions(
                        config: keyboardActionsConfig(
                          focusNodes: [_versionFocusNode],
                        ),
                        disableScroll: true,
                        child: TextField(
                          focusNode: _versionFocusNode,
                          textInputAction: TextInputAction.done,
                          controller: _versionController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],

                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter Version',
                            labelStyle: TextStyle(
                              color: AppColors.textColorPrimary, // Label color when not focused
                              fontSize: AppData.text22, // Label font size
                            ),
                            filled: true,
                            fillColor: AppColors.textFieldColor,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderPrimary,
                                // Border color when the TextField is not focused
                                width: 2.0, // Border width
                              ),
                              borderRadius: BorderRadius.circular(4.0), // Rounded corners
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                // Border color when the TextField is focused
                                width: 2.0, // Border width
                              ),
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
                    )),

                SizedBox(height: AppData.spacingStandard),

                Padding(
                    padding: EdgeInsets.only(left: AppData.padding16, right: AppData.padding16),
                    child: Container(
                      width: AppData.inputFieldWidth,
                      child: KeyboardActions(
                        config: keyboardActionsConfig(
                          focusNodes: [_lengthFocusNode],
                        ),
                        disableScroll: true,
                        child: TextField(
                          focusNode: _lengthFocusNode,
                          textInputAction: TextInputAction.done,
                          controller: _lengthController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],

                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter Password Length',
                            labelStyle: TextStyle(
                              color: AppColors.textColorPrimary, // Label color when not focused
                              fontSize: AppData.text22, // Label font size
                            ),
                            filled: true,
                            fillColor: AppColors.textFieldColor,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderPrimary,
                                // Border color when the TextField is not focused
                                width: 2.0, // Border width
                              ),
                              borderRadius: BorderRadius.circular(4.0), // Rounded corners
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                // Border color when the TextField is focused
                                width: 2.0, // Border width
                              ),
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
                    )),

                SizedBox(height: AppData.spacingStandard),

                Padding(
                  padding: EdgeInsets.only(left: AppData.padding16, right: AppData.padding16),
                  child: Container(
                    width: AppData.inputFieldWidth,
                    padding: EdgeInsets.symmetric(horizontal: AppData.padding12, vertical: AppData.padding8),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: AppColors.borderPrimary, width: 2.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _charRule,
                        isExpanded: true,
                        dropdownColor: AppColors.textFieldColor2,
                        style: TextStyle(
                          color: AppColors.textColorPrimary,
                          fontSize: AppData.text24,
                          fontWeight: FontWeight.bold,
                        ),
                        iconEnabledColor: AppColors.textColorPrimary,
                        items: const [
                          DropdownMenuItem(
                            value: 'full',
                            child: Text('Full Characters'),
                          ),
                          DropdownMenuItem(
                            value: 'limited',
                            child: Text('Limited Characters'),
                          ),
                          DropdownMenuItem(
                            value: 'strict',
                            child: Text('Strict Alphanumeric'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _charRule = value ?? 'full';
                          });
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppData.spacingStandard),

                Padding(
                  padding: EdgeInsets.only(left: AppData.padding16, right: AppData.padding16, bottom: AppData.padding16),
                  child: ElevatedButton(
                    onPressed: _generate,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      textStyle: TextStyle(fontSize: AppData.text24, fontWeight: FontWeight.bold),
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: AppData.padding20, vertical: AppData.padding10),
                      elevation: 15,
                      shadowColor: Colors.black,
                      side: const BorderSide(color: Colors.black, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: AppData.padding8, vertical: AppData.padding16),
                      child: const Text('Generate'),
                    ),
                  ),
                ),
                 SizedBox(height: AppData.sizedBox22),

                if (_generatedPassword.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: AppData.padding16,
                        right: AppData.padding16,
                        bottom: AppData.padding16,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.borderPrimary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.white, // background of main box
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppData.padding12,
                                vertical: AppData.padding8,
                              ),
                              color: AppColors.textFieldColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Hashed Password:',
                                    style: TextStyle(
                                      fontSize: AppData.text22,
                                      color: AppColors.textColorPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.file_upload_outlined, color: AppColors.textColorPrimary, size: AppData.text32,),
                                      tooltip: 'Send to Laptop Clipboard',
                                      onPressed: () async {
                                        String? existingIp = await ClipboardSettings.getLaptopIP();

                                        if (existingIp == null) {
                                          final controller = TextEditingController();
                                          final enteredIp = await showDialog<String>(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Enter IP'),
                                                content: TextField(
                                                  controller: controller,
                                                  decoration: InputDecoration(hintText: 'e.g. 192.168.0.23'),
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                ),
                                                actions: [
                                                  TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, controller.text.trim()),
                                                    child: Text('Save'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (enteredIp != null && enteredIp.isNotEmpty) {
                                            await ClipboardSettings.setLaptopIP(enteredIp);
                                          }
                                        }

                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => Center(
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                                            ),
                                          ),
                                        );

                                        final success = await sendToLaptopClipboard(_generatedPassword);

                                        Navigator.of(context).pop(); // Remove the loading dialog

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              success ? 'Sent to laptop clipboard' : 'Server not running or unreachable',
                                              style: TextStyle(
                                                fontSize: AppData.text20,
                                                color:  success ? Colors.black : Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            backgroundColor: success ? Colors.green : Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                  ),

                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppData.padding12,
                                vertical: AppData.padding8,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SelectableText(
                                      _generatedPassword,
                                      style: TextStyle(
                                        fontSize: AppData.text32,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColorSecondary,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy, color: AppColors.textColorSecondary),
                                    tooltip: 'Copy to clipboard',
                                    onPressed: () async {
                                      if (_generatedPassword.isNotEmpty) {
                                        await Clipboard.setData(ClipboardData(text: _generatedPassword));

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Copied to clipboard!',
                                              style: TextStyle(
                                                fontSize: AppData.text18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                  ),

                                ],
                              )

                            ),
                          ],
                        ),
                      ),
                    ),
                  ),



              ],
            ),
          ),
        ],
      ),
    );
  }
}
