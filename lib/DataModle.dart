class DataModel {
  final int _errorCode;
  final String _message;
  final int _mobileAppUrlId;
  final String _appTitle;
  final String _ownerName;
  final String _regDate;
  final String _url;
  final String _logoUrl;
  final int _systemId;

  // سازنده کلاس
  DataModel(
      this._errorCode,
      this._message,
      this._mobileAppUrlId,
      this._appTitle,
      this._ownerName,
      this._regDate,
      this._url,
      this._logoUrl,
      this._systemId,
      );

  int get errorCode => _errorCode;

  String get message => _message;

  int get mobileAppUrlId => _mobileAppUrlId;

  String get AppTitle => _appTitle;

  String get OwnerName => _ownerName;

  String get RegDate => _regDate;

  String get Url => _url;

  String get LogoUrl => _logoUrl;

  int get SystemId => _systemId;
}