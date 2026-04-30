using StringTools;
using Lambda;

class Factorial {
  // iterative
  static function factorial1(n:Int):Int {
    var result = 1;
    while (1<n)
      result *= n--;
    return result;
  }

  // recursive
  static function factorial2(n:Int):Int {
    return n == 0 ? 1 : n * factorial2(n - 1);
  }

  // tail-recursive
  inline static function _fac_aux(n, acc:Int):Int {
    return n < 1 ? acc : _fac_aux(n - 1, acc * n);
  }

  static function factorial3(n:Int):Int {
    return _fac_aux(n,1);
  }

  // functional
  static function factorial4(n:Int):Int {
    return [for (i in 1...(n+1)) i].fold(function(num, total) return total *= num, 1);
  }

  static function main() {
    var v = 12;
    // iterative
    var start = haxe.Timer.stamp();
    var result = factorial1(v);
    var duration = haxe.Timer.stamp() - start;
    Sys.println('iterative'.rpad(' ', 20) + 'result: $result time: $duration ms');

    // recursive
    start = haxe.Timer.stamp();
    result = factorial2(v);
    duration = haxe.Timer.stamp() - start;
    Sys.println('recursive'.rpad(' ', 20) + 'result: $result time: $duration ms');

    // tail-recursive
    start = haxe.Timer.stamp();
    result = factorial3(v);
    duration = haxe.Timer.stamp() - start;
    Sys.println('tail-recursive'.rpad(' ', 20) + 'result: $result time: $duration ms');

    // functional
    start = haxe.Timer.stamp();
    result = factorial4(v);
    duration = haxe.Timer.stamp() - start;
    Sys.println('functional'.rpad(' ', 20) + 'result: $result time: $duration ms');
  }
}
