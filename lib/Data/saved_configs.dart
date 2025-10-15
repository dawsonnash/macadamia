import 'package:hive/hive.dart';
import 'config.dart';

class SavedConfigs {
  List<Config> configurations = [];

  SavedConfigs({this.configurations = const []});

  Future<void> loadConfigsFromHive() async {
    var configBox = Hive.box<Config>('configBox');
    configurations = configBox.values.toList();
  }

  Future<void> addConfig(Config config) async {
    var configBox = Hive.box<Config>('configBox');
    await configBox.add(config); // persist to Hive
    configurations.add(config);  // update in-memory list
  }

  Future<void> removeConfig(Config config) async {
    var configBox = Hive.box<Config>('configBox');
    await config.delete(); // deletes from Hive
    configurations.remove(config); // update in-memory list
  }
}

final SavedConfigs savedConfigs = SavedConfigs();
