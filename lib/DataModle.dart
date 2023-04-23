class DataModel {
  final int _mobileAppUrlId;
  final String _appTitle;
  final String _ownerName;
  final String _regDate;
  final String _url;
  final String _logoUrl;
  final int _systemId;

  // سازنده کلاس
  DataModel(
    this._mobileAppUrlId,
    this._appTitle,
    this._ownerName,
    this._regDate,
    this._url,
    this._logoUrl,
    this._systemId,
  );

  int get mobileAppUrlId => _mobileAppUrlId;

  String get appTitle => _appTitle;

  String get ownerName => _ownerName;

  String get regDate => _regDate;

  String get url => _url;

  String get logoUrl => _logoUrl;

  int get systemId => _systemId;
}
