import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:driver_app/domain/user.dart';
import 'package:driver_app/util/app_url.dart';
import 'package:driver_app/util/storage.dart';
import 'package:http/http.dart';

Future<Map<String, dynamic>> stat() async {
  String token = await UserPreferences().getToken();
  User user = await UserPreferences().getUser();
  try {
    Response response = await post(
      Uri.parse(AppUrl.driverStat),
      body: {
        'user_id': user.userId.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    inspect(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> driverStat = json.decode(response.body)['stat'];
      Map<String, dynamic> driverAvg = json.decode(response.body)['avg'];
      return {
        'status': true,
        'stat': driverStat,
        'avg': driverAvg,
      };
    } else {
      return {
        'status': false,
        'message': json.decode(response.body)['message'],
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> activity() async {
  String token = await UserPreferences().getToken();
  User user = await UserPreferences().getUser();
  try {
    Response response = await post(
      Uri.parse(AppUrl.driverActivity),
      body: {
        'user_id': user.userId.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> current = json.decode(response.body)['current'];
      return {
        'status': true,
        'current': current,
      };
    } else {
      return {
        'status': false,
        'message': 'Aucune activité en cours',
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> passedActivity() async {
  String token = await UserPreferences().getToken();
  User user = await UserPreferences().getUser();
  try {
    Response response = await post(
      Uri.parse(AppUrl.driverPassedActivity),
      body: {
        'user_id': user.userId.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> passed = json.decode(response.body)['passed'];
      if (passed.isEmpty) {
        return {
          'status': false,
          'message': 'Aucune activité récentes',
        };
      }
      return {
        'status': true,
        'passed': passed,
      };
    } else {
      return {
        'status': false,
        'message': 'Aucune activité récentes',
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> futureActivity() async {
  String token = await UserPreferences().getToken();
  User user = await UserPreferences().getUser();
  try {
    Response response = await post(
      Uri.parse(AppUrl.driverFutureActivity),
      body: {
        'user_id': user.userId.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> future = json.decode(response.body)['future'];
      if (future.isEmpty) {
        return {
          'status': false,
          'message': 'Aucune activité à venir',
        };
      }
      return {
        'status': true,
        'future': future,
      };
    } else {
      return {
        'status': false,
        'message': 'Aucune activité à venir',
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> controlTicket(String ticketNumber) async {
  String token = await UserPreferences().getToken();
  try {
    Response response = await post(
      Uri.parse(AppUrl.control),
      body: {
        'ticket_number': ticketNumber,
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return {
        'status': true,
        'status_code': response.statusCode,
        'message': json.decode(response.body)['message'],
      };
    } else {
      return {
        'status': false,
        'status_code': response.statusCode,
        'message': json.decode(response.body)['message'],
      };
    }
  } on HttpException {
    throw Exception('erreur');
  }
}

Future<Map<String, dynamic>> controlQrTicket(String qrData) async {
  String token = await UserPreferences().getToken();
  try {
    Response response = await post(
      Uri.parse(AppUrl.controlQr),
      body: {
        'qr_data': qrData,
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return {
        'status': true,
        'status_code': response.statusCode,
        'message': json.decode(response.body)['message'],
      };
    } else {
      return {
        'status': false,
        'status_code': response.statusCode,
        'message': json.decode(response.body)['message'],
      };
    }
  } on HttpException {
    throw Exception('erreur');
  }
}
