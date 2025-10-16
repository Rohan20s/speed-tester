import 'package:hive/hive.dart';

part 'speed_test_result.g.dart';

@HiveType(typeId: 0)
class SpeedTestResult extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double downloadSpeed;

  @HiveField(2)
  final double uploadSpeed;

  @HiveField(3)
  final double ping;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String deviceModel;

  @HiveField(6)
  final String deviceBrand;

  @HiveField(7)
  final String androidVersion;

  @HiveField(8)
  final String networkType;

  @HiveField(9)
  final String carrierName;

  @HiveField(10)
  final String location;

  @HiveField(11)
  final int testDuration;

  @HiveField(12)
  final String deviceName;

  @HiveField(13)
  final String product;

  @HiveField(14)
  final String hardware;

  @HiveField(15)
  final String fingerprint;

  @HiveField(16)
  final String host;

  @HiveField(17)
  final String tags;

  @HiveField(18)
  final String type;

  @HiveField(19)
  final bool isPhysicalDevice;

  @HiveField(20)
  final List<String> systemFeatures;

  @HiveField(21)
  final String securityPatch;

  @HiveField(22)
  final String codename;

  @HiveField(23)
  final String incremental;

  SpeedTestResult({
    required this.id,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ping,
    required this.timestamp,
    required this.deviceModel,
    required this.deviceBrand,
    required this.androidVersion,
    required this.networkType,
    required this.carrierName,
    required this.location,
    required this.testDuration,
    required this.deviceName,
    required this.product,
    required this.hardware,
    required this.fingerprint,
    required this.host,
    required this.tags,
    required this.type,
    required this.isPhysicalDevice,
    required this.systemFeatures,
    required this.securityPatch,
    required this.codename,
    required this.incremental,
  });

  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  String get speedRating {
    final avgSpeed = (downloadSpeed + uploadSpeed) / 2;
    if (avgSpeed >= 50) return 'Excellent';
    if (avgSpeed >= 25) return 'Good';
    if (avgSpeed >= 10) return 'Fair';
    return 'Poor';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'downloadSpeed': downloadSpeed,
      'uploadSpeed': uploadSpeed,
      'ping': ping,
      'timestamp': timestamp.toIso8601String(),
      'deviceModel': deviceModel,
      'deviceBrand': deviceBrand,
      'androidVersion': androidVersion,
      'networkType': networkType,
      'carrierName': carrierName,
      'location': location,
      'testDuration': testDuration,
      'deviceName': deviceName,
      'product': product,
      'hardware': hardware,
      'fingerprint': fingerprint,
      'host': host,
      'tags': tags,
      'type': type,
      'isPhysicalDevice': isPhysicalDevice,
      'systemFeatures': systemFeatures,
      'securityPatch': securityPatch,
      'codename': codename,
      'incremental': incremental,
    };
  }

  factory SpeedTestResult.fromJson(Map<String, dynamic> json) {
    return SpeedTestResult(
      id: json['id'],
      downloadSpeed: json['downloadSpeed'],
      uploadSpeed: json['uploadSpeed'],
      ping: json['ping'],
      timestamp: DateTime.parse(json['timestamp']),
      deviceModel: json['deviceModel'],
      deviceBrand: json['deviceBrand'],
      androidVersion: json['androidVersion'],
      networkType: json['networkType'],
      carrierName: json['carrierName'],
      location: json['location'],
      testDuration: json['testDuration'] ?? 0,
      deviceName: json['deviceName'] ?? '',
      product: json['product'] ?? '',
      hardware: json['hardware'] ?? '',
      fingerprint: json['fingerprint'] ?? '',
      host: json['host'] ?? '',
      tags: json['tags'] ?? '',
      type: json['type'] ?? '',
      isPhysicalDevice: json['isPhysicalDevice'] ?? false,
      systemFeatures: List<String>.from(json['systemFeatures'] ?? []),
      securityPatch: json['securityPatch'] ?? '',
      codename: json['codename'] ?? '',
      incremental: json['incremental'] ?? '',
    );
  }
}