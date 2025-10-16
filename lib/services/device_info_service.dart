import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Connectivity _connectivity = Connectivity();

  Future<Map<String, dynamic>> getCompleteDeviceInfo() async {
    try {
      final deviceInfo = await _getDeviceInfo();
      final networkInfo = await _getNetworkInfo();
      final locationInfo = await _getLocationInfo();
      
      return {
        ...deviceInfo,
        ...networkInfo,
        ...locationInfo,
      };
    } catch (e) {
      return await _getFallbackInfo();
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        
        return {
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'manufacturer': androidInfo.manufacturer,
          'version': 'Android ${androidInfo.version.release}',
          'apiLevel': androidInfo.version.sdkInt,
          'deviceName': androidInfo.device,
          'product': androidInfo.product,
          'hardware': androidInfo.hardware,
          'fingerprint': androidInfo.fingerprint,
          'host': androidInfo.host,
          'tags': androidInfo.tags,
          'type': androidInfo.type,
          'isPhysicalDevice': androidInfo.isPhysicalDevice,
          'systemFeatures': androidInfo.systemFeatures,
          'securityPatch': androidInfo.version.securityPatch,
          'codename': androidInfo.version.codename,
          'incremental': androidInfo.version.incremental,
          'release': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
          'previewSdkInt': androidInfo.version.previewSdkInt,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        
        return {
          'model': iosInfo.model,
          'brand': 'Apple',
          'manufacturer': 'Apple',
          'version': 'iOS ${iosInfo.systemVersion}',
          'apiLevel': iosInfo.systemVersion,
          'deviceName': iosInfo.name,
          'systemName': iosInfo.systemName,
          'localizedModel': iosInfo.localizedModel,
          'identifierForVendor': iosInfo.identifierForVendor,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
          'utsname': {
            'sysname': iosInfo.utsname.sysname,
            'nodename': iosInfo.utsname.nodename,
            'release': iosInfo.utsname.release,
            'version': iosInfo.utsname.version,
            'machine': iosInfo.utsname.machine,
          },
        };
      }
    } catch (e) {
      // Fallback
    }
    
    return await _getFallbackInfo();
  }

  Future<Map<String, dynamic>> _getNetworkInfo() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      String networkType = 'Unknown';
      String carrierName = 'Unknown Carrier';
      
      if (connectivityResult is List) {
        final results = connectivityResult as List<ConnectivityResult>;
        
        if (results.contains(ConnectivityResult.wifi)) {
          networkType = 'Wi-Fi';
          carrierName = 'Wi-Fi Network';
        } else if (results.contains(ConnectivityResult.mobile)) {
          networkType = 'Mobile Data';
          carrierName = await _getMobileCarrierName();
        } else if (results.contains(ConnectivityResult.ethernet)) {
          networkType = 'Ethernet';
          carrierName = 'Ethernet Connection';
        } else if (results.contains(ConnectivityResult.bluetooth)) {
          networkType = 'Bluetooth';
          carrierName = 'Bluetooth Connection';
        } else if (results.contains(ConnectivityResult.vpn)) {
          networkType = 'VPN';
          carrierName = 'VPN Connection';
        } else if (results.contains(ConnectivityResult.none)) {
          networkType = 'No Connection';
          carrierName = 'No Network';
        } else {
          networkType = 'Other';
          carrierName = 'Other Network';
        }
      }

      return {
        'networkType': networkType,
        'carrierName': carrierName,
      };
    } catch (e) {
      return {
        'networkType': 'Unknown',
        'carrierName': 'Unknown Carrier',
      };
    }
  }

  Future<String> _getMobileCarrierName() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      
      if (connectivityResults is List && connectivityResults.contains(ConnectivityResult.mobile) ||
          connectivityResults == ConnectivityResult.mobile) {
        if (Platform.isAndroid) {
          try {
            final androidInfo = await _deviceInfo.androidInfo;
            final brand = androidInfo.brand.toLowerCase();
            final model = androidInfo.model.toLowerCase();
            
            if (brand.contains('samsung')) {
              return 'Samsung Mobile';
            } else if (brand.contains('xiaomi') || brand.contains('redmi')) {
              return 'Xiaomi Mobile';
            } else if (brand.contains('oneplus')) {
              return 'OnePlus Mobile';
            } else if (brand.contains('huawei') || brand.contains('honor')) {
              return 'Huawei Mobile';
            } else if (brand.contains('oppo')) {
              return 'OPPO Mobile';
            } else if (brand.contains('vivo')) {
              return 'Vivo Mobile';
            } else if (brand.contains('realme')) {
              return 'Realme Mobile';
            } else if (brand.contains('motorola')) {
              return 'Motorola Mobile';
            } else if (brand.contains('nokia')) {
              return 'Nokia Mobile';
            } else if (brand.contains('lg')) {
              return 'LG Mobile';
            } else if (brand.contains('sony')) {
              return 'Sony Mobile';
            } else if (brand.contains('google') || model.contains('pixel')) {
              return 'Google Pixel';
            } else if (brand.contains('poco')) {
              return 'POCO Mobile';
            } else if (brand.contains('infinix')) {
              return 'Infinix Mobile';
            } else if (brand.contains('tecno')) {
              return 'Tecno Mobile';
            } else if (brand.contains('itel')) {
              return 'Itel Mobile';
            } else if (brand.contains('lava')) {
              return 'Lava Mobile';
            } else if (brand.contains('micromax')) {
              return 'Micromax Mobile';
            } else if (brand.contains('karbonn')) {
              return 'Karbonn Mobile';
            } else if (brand.contains('nothing')) {
              return 'Nothing Phone';
            } else if (brand.contains('fairphone')) {
              return 'Fairphone';
            } else if (brand.contains('asus')) {
              return 'ASUS Mobile';
            } else if (brand.contains('htc')) {
              return 'HTC Mobile';
            } else if (brand.contains('blackberry')) {
              return 'BlackBerry Mobile';
            } else if (brand.contains('meizu')) {
              return 'Meizu Mobile';
            } else if (brand.contains('lenovo')) {
              return 'Lenovo Mobile';
            } else if (brand.contains('zte')) {
              return 'ZTE Mobile';
            } else if (brand.contains('alcatel')) {
              return 'Alcatel Mobile';
            } else if (brand.contains('tcl')) {
              return 'TCL Mobile';
            } else {
              return '${androidInfo.brand} Mobile';
            }
          } catch (e) {
            return 'Android Mobile';
          }
        } else if (Platform.isIOS) {
          try {
            final iosInfo = await _deviceInfo.iosInfo;
            final model = iosInfo.model.toLowerCase();
            
            if (model.contains('iphone')) {
              return 'iPhone Mobile';
            } else if (model.contains('ipad')) {
              return 'iPad Mobile';
            } else {
              return 'iOS Mobile';
            }
          } catch (e) {
            return 'iOS Mobile';
          }
        }
      }
      
      return 'Mobile Data';
    } catch (e) {
      return 'Mobile Data';
    }
  }

  Future<Map<String, dynamic>> _getLocationInfo() async {
    try {
      final permission = await Permission.location.status;
      if (permission.isDenied) {
        await Permission.location.request();
      }

      if (permission.isGranted) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 10),
        );
        
        final locationText = await _getLocationText(position.latitude, position.longitude);
        
        return {
          'location': locationText,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'altitude': position.altitude,
          'accuracy': position.accuracy,
        };
      } else {
        return await _getFallbackLocation();
      }
    } catch (e) {
      return await _getFallbackLocation();
    }
  }

  Future<String> _getLocationText(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final city = data['city'] ?? data['locality'] ?? '';
        final country = data['countryName'] ?? '';
        final state = data['principalSubdivision'] ?? '';
        
        if (city.isNotEmpty && country.isNotEmpty) {
          return state.isNotEmpty ? '$city, $state, $country' : '$city, $country';
        } else if (country.isNotEmpty) {
          return country;
        }
      }
    } catch (e) {
      // Fallback to coordinates
    }
    
    return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
  }

  Future<Map<String, dynamic>> _getFallbackLocation() async {
    const fallbackLat = 20.5937;
    const fallbackLng = 78.9629;
    
    final locationText = await _getLocationText(fallbackLat, fallbackLng);
    
    return {
      'location': locationText,
      'latitude': fallbackLat,
      'longitude': fallbackLng,
      'altitude': 0.0,
      'accuracy': 0.0,
    };
  }

  Future<Map<String, dynamic>> getStorageInfo() async {
    return {
      'totalStorage': 0,
      'availableStorage': 0,
      'usedStorage': 0,
      'storageUsagePercentage': 0.0,
      'note': 'Storage information not available from device API',
    };
  }

  Future<Map<String, dynamic>> _getFallbackInfo() async {
    return {
      'model': 'Unknown Device',
      'brand': 'Unknown',
      'manufacturer': 'Unknown',
      'version': 'Unknown',
      'apiLevel': 0,
      'networkType': 'Unknown',
      'carrierName': 'Unknown Carrier',
      'location': 'Unknown',
      'latitude': 0.0,
      'longitude': 0.0,
      'altitude': 0.0,
      'accuracy': 0.0,
      'deviceName': 'Unknown',
      'product': 'Unknown',
      'hardware': 'Unknown',
      'fingerprint': 'Unknown',
      'host': 'Unknown',
      'tags': 'Unknown',
      'type': 'Unknown',
      'isPhysicalDevice': false,
      'systemFeatures': [],
      'securityPatch': 'Unknown',
      'codename': 'Unknown',
      'incremental': 'Unknown',
    };
  }
}