class LoginDataModel {
  final int _errorCode;
  final String _message;
  final int _userID;
  final List<String> _perms;
  // سازنده کلاس
  LoginDataModel(
    this._errorCode,
    this._message,
    this._userID,
    this._perms,
  );

  int get errorCode => _errorCode;

  String get message => _message;

  int get userId => _userID;

  List<String> get perms => _perms;
}
