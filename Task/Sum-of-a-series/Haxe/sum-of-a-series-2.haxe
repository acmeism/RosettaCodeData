using Lambda;
using StringTools;

class Main {
  static function main() {	
    var approx = [for (x in 1...1001) x].fold(function(x, sum) return sum += 1.0 / (x * x), 0);
    Sys.println('Approximation: $approx');
    Sys.println('Exact: '.lpad(' ', 15) + Math.PI * Math.PI / 6);
  }
}
