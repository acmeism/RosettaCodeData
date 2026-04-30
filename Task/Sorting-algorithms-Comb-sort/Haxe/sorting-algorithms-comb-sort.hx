class CombSort {
  @:generic
  public static function sort<T>(arr:Array<T>) {
    var gap:Float = arr.length;
    var swaps = true;
    while (gap > 1 || swaps) {
      gap /= 1.247330950103979;
      if (gap < 1) gap = 1.0;
      var i = 0;
      swaps = false;
      while (i + gap < arr.length) {
        var igap = i + Std.int(gap);
        if (Reflect.compare(arr[i], arr[igap]) > 0) {
          var temp = arr[i];
          arr[i] = arr[igap];
          arr[igap] = temp;
          swaps = true;
        }
        i++;
      }
    }
  }
}

class Main {
  static function main() {
    var integerArray   = [1, 10, 2, 5, -1, 5, -19, 4, 23, 0];
    var floatArray = [1.0, -3.2, 5.2, 10.8, -5.7, 7.3,
                      3.5, 0.0, -4.1, -9.5];
    var stringArray = ['We', 'hold', 'these', 'truths', 'to',
                       'be', 'self-evident', 'that', 'all',
                       'men', 'are', 'created', 'equal'];
    Sys.println('Unsorted Integers: ' + integerArray);
    CombSort.sort(integerArray);
    Sys.println('Sorted Integers:   ' + integerArray);
    Sys.println('Unsorted Floats:   ' + floatArray);
    CombSort.sort(floatArray);
    Sys.println('Sorted Floats:     ' + floatArray);
    Sys.println('Unsorted Strings:  ' + stringArray);
    CombSort.sort(stringArray);
    Sys.println('Sorted Strings:    ' + stringArray);
  }
}
