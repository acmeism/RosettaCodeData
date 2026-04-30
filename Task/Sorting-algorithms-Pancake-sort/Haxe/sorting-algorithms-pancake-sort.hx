class PancakeSort {
  @:generic
  inline private static function flip<T>(arr:Array<T>, num:Int) {
    var i = 0;
    while (i < --num) {
      var temp = arr[i];
      arr[i++] = arr[num];
      arr[num] = temp;
    }
  }

  @:generic
  public static function sort<T>(arr:Array<T>) {
    if (arr.length < 2) return;

    var i = arr.length;
    while (i > 1) {
      var maxNumPos = 0;
      for (a in 0...i) {
        if (Reflect.compare(arr[a], arr[maxNumPos]) > 0)
          maxNumPos = a;
      }
      if (maxNumPos == i - 1) i--;
      if (maxNumPos > 0) flip(arr, maxNumPos + 1);
      flip(arr, i--);
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
    PancakeSort.sort(integerArray);
    Sys.println('Sorted Integers:   ' + integerArray);
    Sys.println('Unsorted Floats:   ' + floatArray);
    PancakeSort.sort(floatArray);
    Sys.println('Sorted Floats:     ' + floatArray);
    Sys.println('Unsorted Strings:  ' + stringArray);
    PancakeSort.sort(stringArray);
    Sys.println('Sorted Strings:    ' + stringArray);
  }
}
