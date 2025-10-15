// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigAdapter extends TypeAdapter<Config> {
  @override
  final int typeId = 0;

  @override
  Config read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Config(
      version: fields[0] as int,
      passwordLength: fields[1] as int,
      siteKey: fields[2] as String,
      charRule: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Config obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.version)
      ..writeByte(1)
      ..write(obj.passwordLength)
      ..writeByte(2)
      ..write(obj.siteKey)
      ..writeByte(3)
      ..write(obj.charRule);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
