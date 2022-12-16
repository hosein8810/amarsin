int customerId = 0;

class OrdDtlModle {
  final String _pName;
  final int _cnt;
  final int _offer;
  final int _cost;
  final int _pId;

  OrdDtlModle(
    this._cnt,
    this._offer,
    this._cost,
    this._pId,
    this._pName
        );

  String get pName => _pName;
  int get cnt => _cnt;
  int get offer => _offer;
  int get cost => _cost;
  int get pId => _pId;
}
