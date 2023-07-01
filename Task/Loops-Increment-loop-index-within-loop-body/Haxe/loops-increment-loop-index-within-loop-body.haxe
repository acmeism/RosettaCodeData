using StringTools;
import haxe.Int64;

class PrimeNumberLoops {
  private static var limit = 42;

  static function isPrime(i:Int64):Bool {
    if (i == 2 || i == 3) {
      return true;
    } else if (i % 2 == 0 || i % 3 ==0) {
      return false;
    }
    var idx:haxe.Int64 = 5;
    while (idx * idx <= i) {
      if (i % idx == 0) return false;
      idx += 2;
      if (i % idx == 0) return false;
      idx += 4;
    }
    return true;
  }

  static function main() {
    var i:Int64 = 42;
    var n:Int64 = 0;
    while (n < limit) {
      if (isPrime(i)) {
        n++;
        Sys.println('n ${Int64.toStr(n).lpad(' ', 2)} ' +
                    '= ${Int64.toStr(i).lpad(' ', 19)}');
        i += i;
        continue;
      }
      i++;
    }
  }
}
