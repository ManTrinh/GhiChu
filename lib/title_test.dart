import 'package:flutter/material.dart';

class TitleList with ChangeNotifier {
  String _title = "";
  String _url = "";
  String _account = "";
  String _password = "";

  set newTilte(newVal) {
    _title = newVal;
    notifyListeners();
  }

  set newUrl(newVal) {
    _url = newVal;
    notifyListeners();
  }

  set newAccount(newVal) {
    _account = newVal;
    notifyListeners();
  }

  set newPassword(newVal) {
    _password = newVal;
    notifyListeners();
  }

  String get getTitle => _title;
  String get getAccount => _account;
  String get getPassword => _password;
  String get getUrl => _url;

  int _index = 0;
  set newIdx(newVal) {
    _index = newVal;
    notifyListeners();
  }

  int get getIdx => _index;
}

class objTextData{

  //objTextData(this._nIdx, this._title, this._url, this._account, this._passwords);
  objTextData(this._title, this._url, this._account, this._passwords);

  //final int _nIdx;
  String _title;
  String _url;
  String _account;
  String _passwords;

  set newTilte(newVal) {
    _title = newVal;
  }

  set newUrl(newVal) {
    _url = newVal;
  }

  set newAccount(newVal) {
    _account = newVal;
  }

  set newPassword(newVal) {
    _passwords = newVal;
  }

  //int get getIndex => _nIdx;
  String get getTitle => _title;
  String get getUrl => _url;
  String get getAccount => _account;
  String get getPasswords => _passwords;
}
