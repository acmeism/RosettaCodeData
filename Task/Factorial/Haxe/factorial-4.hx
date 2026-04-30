static function factorial(n:Int):Int {
  return [for (i in 1...(n+1)) i].fold(function(num, total) return total *= num, 1);
}
