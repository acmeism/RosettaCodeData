inline static function _fac_aux(n, acc:Int):Int {
  return n < 1 ? acc : _fac_aux(n - 1, acc * n);
}

static function factorial(n:Int):Int {
  return _fac_aux(n,1);
}
