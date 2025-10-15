import 'package:hive/hive.dart';

part 'config.g.dart';

@HiveType(typeId: 0)
class Config extends HiveObject {
  @HiveField(0)
  int version;

  @HiveField(1)
  int passwordLength;

  @HiveField(2)
  String siteKey;

  @HiveField(3)
  String charRule;

  Config({
    required this.version,
    required this.passwordLength,
    required this.siteKey,
    required this.charRule, // add to constructor
  });

  Config copyWith({
    int? version,
    int? passwordLength,
    String? siteKey,
    String? charRule, // add to copyWith
  }) {
    return Config(
      version: version ?? this.version,
      passwordLength: passwordLength ?? this.passwordLength,
      siteKey: siteKey ?? this.siteKey,
      charRule: charRule ?? this.charRule,
    );
  }
}
