import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:macadamia/Data/saved_configs.dart';
import 'CodeShare/variables.dart';
import 'Data/config.dart';

class ManageConfigsScreen extends StatefulWidget {
  const ManageConfigsScreen({super.key});

  @override
  State<ManageConfigsScreen> createState() => _ManageConfigsScreenState();
}

class _ManageConfigsScreenState extends State<ManageConfigsScreen> {

  late final Box<Config> configBox;
  List<Config> configList = [];

  @override
  void initState() {
    super.initState();
    // Open the Hive box and load the list of Gear items
    configBox = Hive.box<Config>('configBox');
    loadConfigList();
  }

  // Function to load the list of Gear items from the Hive box
  void loadConfigList() {
    setState(() {
      configList = configBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    TextStyle panelTextStyle = TextStyle(
      fontSize: AppData.text32,
      fontWeight: FontWeight.bold,
      color: AppColors.textColorPrimary,
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.95)),
          Padding(
            padding: EdgeInsets.only(top: AppData.padding16),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      if (configList.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            left: AppData.padding16,
                            right: AppData.padding16,
                            bottom: AppData.padding8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Version',
                                  style: TextStyle(
                                    color: AppColors.textColorPrimary,
                                    fontSize: AppData.text18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppData.sizedBox8),
                              Expanded(
                                child: Text(
                                  'Length',
                                  style: TextStyle(
                                    color: AppColors.textColorPrimary,
                                    fontSize: AppData.text18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppData.sizedBox8),
                              Expanded(
                                child: Text(
                                  'Rule',
                                  style: TextStyle(
                                    color: AppColors.textColorPrimary,
                                    fontSize: AppData.text18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppData.sizedBox8),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Site Key',
                                  style: TextStyle(
                                    color: AppColors.textColorPrimary,
                                    fontSize: AppData.text18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ...configList.map((config) {

                        final controller = TextEditingController(text: config.siteKey);
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );


                        return Dismissible(
                          key: ValueKey(config),
                          // Unique key for each trip
                          direction: DismissDirection.endToStart,
                          // Swipe from right to left
                          background: Container(
                            color: Colors.red, // Background color when swiped
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: AppData.text32,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            // Show a confirmation dialog before deleting
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.textFieldColor2,
                                  title: Text(
                                    'Confirm Deletion',
                                    style: TextStyle(color: AppColors.textColorPrimary,  fontSize: AppData.miniDialogTitleTextSize, ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete this config?',
                                    style: TextStyle(fontSize: AppData.miniDialogBodyTextSize, color: AppColors.textColorPrimary),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog without deleting
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: AppColors.textColorPrimary,  fontSize: AppData.bottomDialogTextSize, ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Perform deletion
                                        savedConfigs.removeConfig(config);

                                        // Update the parent widget state
                                        setState(() {
                                          loadConfigList();
                                        });

                                        // Close the dialogs
                                        Navigator.of(context).pop(); // Close confirmation dialog
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red, fontSize: AppData.bottomDialogTextSize),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            // Perform the delete operation
                            setState(() {
                              savedConfigs.removeConfig(config);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: AppData.padding16, right: AppData.padding16, bottom: AppData.spacingStandard),
                            child: Row(
                              children: [
                                // Version Dropdown
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: AppData.padding12, vertical: AppData.padding8),
                                    decoration: BoxDecoration(
                                      color: AppColors.textFieldColor,
                                      border: Border.all(color: AppColors.borderPrimary, width: 2.0),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: config.version,
                                        dropdownColor: AppColors.textFieldColor,
                                        iconEnabledColor: AppColors.textColorPrimary,
                                        style: TextStyle(
                                          color: AppColors.textColorPrimary,
                                          fontSize: AppData.text16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        items: List.generate(10, (i) => DropdownMenuItem(
                                          value: i + 1,
                                          child: Text('${i + 1}'),
                                        )),
                                        onChanged: (value) {
                                          setState(() {
                                            config.version = value!;
                                            config.save(); // Save it back to Hive
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppData.sizedBox8),

                                // Length Dropdown
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: AppData.padding12, vertical: AppData.padding8),
                                    decoration: BoxDecoration(
                                      color: AppColors.textFieldColor,
                                      border: Border.all(color: AppColors.borderPrimary, width: 2.0),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: config.passwordLength,
                                        dropdownColor: AppColors.textFieldColor,
                                        iconEnabledColor: AppColors.textColorPrimary,
                                        style: TextStyle(
                                          color: AppColors.textColorPrimary,
                                          fontSize: AppData.text16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        items: List.generate(13, (i) => DropdownMenuItem(
                                          value: i + 8,
                                          child: Text('${i + 8}'),
                                        )),
                                        onChanged: (value) {
                                          setState(() {
                                            config.passwordLength = value!;
                                            config.save(); // Save it back to Hive

                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: AppData.sizedBox8),

                                // Char Rule Dropdown
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: AppData.padding12, vertical: AppData.padding8),
                                    decoration: BoxDecoration(
                                      color: AppColors.textFieldColor,
                                      border: Border.all(color: AppColors.borderPrimary, width: 2.0),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: config.charRule, // must be a string like 'F', 'L', or 'S'
                                        dropdownColor: AppColors.textFieldColor,
                                        iconEnabledColor: AppColors.textColorPrimary,
                                        style: TextStyle(
                                          color: AppColors.textColorPrimary,
                                          fontSize: AppData.text16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        items: [
                                          DropdownMenuItem(value: 'F', child: Text('F')),
                                          DropdownMenuItem(value: 'L', child: Text('L')),
                                          DropdownMenuItem(value: 'S', child: Text('S')),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            config.charRule = value!;
                                            config.save();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: AppData.sizedBox8),


                                // Site Key Input
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: controller,
                                    onChanged: (value) {
                                      config.siteKey = value;
                                      config.save();
                                    },

                                    decoration: InputDecoration(
                                      labelText: 'Key',
                                      labelStyle: TextStyle(
                                        color: AppColors.textColorPrimary,
                                        fontSize: AppData.text22,
                                      ),
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
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            final newConfig = Config(
                              version: 1,
                              passwordLength: 16,
                              siteKey: '',
                              charRule: 'F',
                            );

                            await savedConfigs.addConfig(newConfig);
                            loadConfigList();
                            setState(() {}); // Refresh UI if needed
                          },

                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Padding around the text and icon
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                              boxShadow: AppColors.isDarkMode
                                  ? [] // No shadow in dark mode
                                  : [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.5), // Shadow color
                                  spreadRadius: 0, // Spread of the shadow
                                  blurRadius: 20, // Blur effect
                                  offset: Offset(0, 0), // Offset in x and y direction
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Ensures the container width is only as wide as its content
                              children: [
                                Icon(
                                  FontAwesomeIcons.circlePlus,
                                  color: AppColors.primaryColor, size: AppData.text32,
                                ),
                                SizedBox(width: AppData.sizedBox8), // Space between the icon and the text
                                Text(
                                  'Configuration',
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: panelTextStyle,
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
          ),
        ],
      ),
    );
  }
}
