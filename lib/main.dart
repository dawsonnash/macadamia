// stripped down version of the main Flutter UI layout from your Fire Manifest App
// adapted for Macadamia password manager, no Hive, no Firebase, no receive_intent, etc.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:macadamia/Data/config.dart';
import 'package:macadamia/Data/saved_configs.dart';
import 'CodeShare/variables.dart';
import 'change_pin.dart';
import 'generate_password.dart';
import 'ip.dart';
import 'lock_screen.dart';
import 'manage_configs.dart';

main() async {

  // Set up for Hive that needs to run before starting app
  WidgetsFlutterBinding.ensureInitialized();

  // Disable landscape mode temporarily, until UI is implemented
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Disable Impeller
  PlatformDispatcher.instance.onPlatformConfigurationChanged = null;
  await Hive.initFlutter();

  Hive.registerAdapter(ConfigAdapter());

  // Open a Hive boxes to store objects
  await Hive.openBox<Config>('configBox');

  // Load data from Hive
  await savedConfigs.loadConfigsFromHive();

  runApp(const MacadamiaApp());
}

class MacadamiaApp extends StatefulWidget {
  const MacadamiaApp({super.key});

  @override
  State<MacadamiaApp> createState() => _MacadamiaAppState();
}

class _MacadamiaAppState extends State<MacadamiaApp> {
  bool _isUnlocked = false;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Macadamia Password Manager',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryColor,
        ),
      ),
      home: _isUnlocked
          ? const MainScreen()
          : LockScreen(onUnlocked: () {
        setState(() {
          _isUnlocked = true;
        });
      }),
    );
  }
}


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
  GeneratePasswordScreen(),
    ManageConfigsScreen(),
    IPSettingsScreen(),
];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Macadamia',
          style: TextStyle(fontSize: AppData.appBarText, fontWeight: FontWeight.bold, color: AppColors.textColorPrimary),
        ),
        backgroundColor: AppColors.appBarColor,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.textColorPrimary),
            onSelected: (value) {
              if (value == 'change_password') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePinScreen()),
                );              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'change_password',
                child: Row(
                  children: [
                    Icon(Icons.password_outlined, color: Colors.white, size: AppData.text24),
                    SizedBox(width: 8),
                    Text('Change PIN', style: TextStyle(color: Colors.white, fontSize: AppData.text18),),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.tabIconColor,
        unselectedItemColor: AppColors.tabIconColor2,
        backgroundColor: AppColors.appBarColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Generate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.router),
            label: 'IP',
          ),
        ],
      ),
    );
  }
}

