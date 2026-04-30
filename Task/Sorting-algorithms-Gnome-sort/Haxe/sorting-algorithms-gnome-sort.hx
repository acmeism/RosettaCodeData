class GnomeSort {
  @:generic
  public static function sort<T>(arr:Array<T>) {
    var i = 1;
    var j = 2;
    while (i < arr.length) {
      if (Reflect.compare(arr[i - 1], arr[i]) <= 0) {
        i = j++;
      } else {
        var temp = arr[i];
        arr[i] = arr[i - 1];
        arr[i - 1] = temp;
        if (--i == 0) {
          i = j++;
        }
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
    GnomeSort.sort(integerArray);
    Sys.println('Sorted Integers:   ' + integerArray);
    Sys.println('Unsorted Floats:   ' + floatArray);
    GnomeSort.sort(floatArray);
    Sys.println('Sorted Floats:     ' + floatArray);
    Sys.println('Unsorted Strings:  ' + stringArray);
    GnomeSort.sort(stringArray);
    Sys.println('Sorted Strings:    ' + stringArray);
  }
}
