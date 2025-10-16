// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speed_test_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpeedTestResultAdapter extends TypeAdapter<SpeedTestResult> {
  @override
  final int typeId = 0;

  @override
  SpeedTestResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpeedTestResult(
      id: fields[0] as String,
      downloadSpeed: fields[1] as double,
      uploadSpeed: fields[2] as double,
      ping: fields[3] as double,
      timestamp: fields[4] as DateTime,
      deviceModel: fields[5] as String,
      deviceBrand: fields[6] as String,
      androidVersion: fields[7] as String,
      networkType: fields[8] as String,
      carrierName: fields[9] as String,
      location: fields[10] as String,
      testDuration: fields[11] as int,
      deviceName: fields[12] as String,
      product: fields[13] as String,
      hardware: fields[14] as String,
      fingerprint: fields[15] as String,
      host: fields[16] as String,
      tags: fields[17] as String,
      type: fields[18] as String,
      isPhysicalDevice: fields[19] as bool,
      systemFeatures: (fields[20] as List).cast<String>(),
      securityPatch: fields[21] as String,
      codename: fields[22] as String,
      incremental: fields[23] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SpeedTestResult obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.downloadSpeed)
      ..writeByte(2)
      ..write(obj.uploadSpeed)
      ..writeByte(3)
      ..write(obj.ping)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.deviceModel)
      ..writeByte(6)
      ..write(obj.deviceBrand)
      ..writeByte(7)
      ..write(obj.androidVersion)
      ..writeByte(8)
      ..write(obj.networkType)
      ..writeByte(9)
      ..write(obj.carrierName)
      ..writeByte(10)
      ..write(obj.location)
      ..writeByte(11)
      ..write(obj.testDuration)
      ..writeByte(12)
      ..write(obj.deviceName)
      ..writeByte(13)
      ..write(obj.product)
      ..writeByte(14)
      ..write(obj.hardware)
      ..writeByte(15)
      ..write(obj.fingerprint)
      ..writeByte(16)
      ..write(obj.host)
      ..writeByte(17)
      ..write(obj.tags)
      ..writeByte(18)
      ..write(obj.type)
      ..writeByte(19)
      ..write(obj.isPhysicalDevice)
      ..writeByte(20)
      ..write(obj.systemFeatures)
      ..writeByte(21)
      ..write(obj.securityPatch)
      ..writeByte(22)
      ..write(obj.codename)
      ..writeByte(23)
      ..write(obj.incremental);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeedTestResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
