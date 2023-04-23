class OrderMSTmodle {
  String _CustName;
  String _Code;
  String _Date;
  double _SumTotal;

  OrderMSTmodle(this._CustName, this._Code, this._Date, this._SumTotal);

  String get CustName => _CustName;
  String get Code => _Code;
  String get Date => _Date;
  double get SumTotal => _SumTotal;
}
