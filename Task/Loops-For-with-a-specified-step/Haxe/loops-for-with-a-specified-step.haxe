class Step {
  var end:Int;
  var step:Int;
  var index:Int;

  public inline function new(start:Int, end:Int, step:Int) {
    this.index = start;
    this.end = end;
    this.step = step;
  }

  public inline function hasNext() return step > 0 ? end >= index : index >= end;
  public inline function next() return (index += step) - step;
}

class Main {
  static function main() {
    for (i in new Step(2, 8, 2)) {
      Sys.print('$i ');
    }
    Sys.println('WHOM do we appreciate? GRAMMAR! GRAMMAR! GRAMMAR!');
  }
}
