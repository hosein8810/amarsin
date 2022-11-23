class LoginDataModel {
  final int _errorCode;
  final String _message;
  final List<String> _perms;
  // سازنده کلاس
  LoginDataModel(
      this._errorCode,
      this._message,
      this._perms,
      );

  int get errorCode => _errorCode;

  String get message => _message;

  List<String> get perms => _perms;
}