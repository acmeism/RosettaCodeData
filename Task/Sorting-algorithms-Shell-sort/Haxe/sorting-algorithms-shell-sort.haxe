class ShellSort {
  @:generic
  public static function sort<T>(arr:Array<T>) {
    var h = arr.length;
    while (h > 0) {
      h >>= 1;
      for (i in h...arr.length) {
        var k = arr[i];
        var j = i;
        while (j >= h && Reflect.compare(k, arr[j - h]) < 0) {
          arr[j] = arr[j - h];
          j -= h;
        }
        arr[j] = k;
      }
    }
  }
}

class Main {
  static function main() {
    var integerArray = [1, 10, 2, 5, -1, 5, -19, 4, 23, 0];
    var floatArray = [1.0, -3.2, 5.2, 10.8, -5.7, 7.3,
                      3.5, 0.0, -4.1, -9.5];
    var stringArray = ['We', 'hold', 'these', 'truths', 'to',
                       'be', 'self-evident', 'that', 'all',
                       'men', 'are', 'created', 'equal'];
    Sys.println('Unsorted Integers: ' + integerArray);
    ShellSort.sort(integerArray);
    Sys.println('Sorted Integers:   ' + integerArray);
    Sys.println('Unsorted Floats:   ' + floatArray);
    ShellSort.sort(floatArray);
    Sys.println('Sorted Floats:     ' + floatArray);
    Sys.println('Unsorted Strings:  ' + stringArray);
    ShellSort.sort(stringArray);
    Sys.println('Sorted Strings:    ' + stringArray);
  }
}
