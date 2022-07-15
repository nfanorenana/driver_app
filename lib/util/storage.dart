import 'dart:convert';
import 'dart:developer';

import 'package:driver_app/domain/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final _storage = new FlutterSecureStorage();

    await _storage.write(key: 'userId', value: user.userId.toString());
    await _storage.write(key: 'name', value: user.name);
    await _storage.write(key: 'username', value: user.username);
    await _storage.write(key: 'email', value: user.email);
    await _storage.write(key: 'token', value: user.token);
    await _storage.write(key: 'renewalToken', value: user.renewalToken);

    return true;
  }

  Future<User> getUser() async {
    const _storage = FlutterSecureStorage();

    int userId;
    String name;
    String username;
    String email;
    String token;
    String renewalToken;
    if ((await _storage.read(key: 'userId')) != null) {
      userId = int.parse(await _storage.read(key: 'userId'));
    }
    if ((await _storage.read(key: 'name')) != null) {
      name = await _storage.read(key: 'name');
    }
    if ((await _storage.read(key: 'username')) != null) {
      username = await _storage.read(key: 'username');
    }
    if ((await _storage.read(key: 'email')) != null) {
      email = await _storage.read(key: 'email');
    }
    if ((await _storage.read(key: 'token')) != null) {
      token = await _storage.read(key: 'token');
    }
    if ((await _storage.read(key: 'renewalToken')) != null) {
      renewalToken = await _storage.read(key: 'renewalToken');
    }

    return User(
      userId: userId,
      name: name,
      username: username,
      email: email,
      token: token,
      renewalToken: renewalToken,
    );
  }

  void removeUser() async {
    final _storage = new FlutterSecureStorage();

    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'name');
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'userId');
  }

  Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();

    String token = await _storage.read(key: 'token');

    return token;
  }
}
