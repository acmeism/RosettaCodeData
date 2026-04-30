using StringTools;

class Main {
  static function main() {
    var sum = 0.0;
    for (x in 1...1001)
      sum += 1.0/(x * x);
    Sys.println('Approximation: $sum');
    Sys.println('Exact: '.lpad(' ', 15) + Math.PI * Math.PI / 6);
  }
}
