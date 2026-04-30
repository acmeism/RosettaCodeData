class InsertionSort {
  @:generic
  public static function sort<T>(arr:Array<T>) {
    for (i in 1...arr.length) {
      var value = arr[i];
      var j = i - 1;
      while (j >= 0 && Reflect.compare(arr[j], value) > 0) {
        arr[j + 1] = arr[j--];
      }
      arr[j + 1] = value;
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
    InsertionSort.sort(integerArray);
    Sys.println('Sorted Integers:   ' + integerArray);
    Sys.println('Unsorted Floats:   ' + floatArray);
    InsertionSort.sort(floatArray);
    Sys.println('Sorted Floats:     ' + floatArray);
    Sys.println('Unsorted Strings:  ' + stringArray);
    InsertionSort.sort(stringArray);
    Sys.println('Sorted Strings:    ' + stringArray);
  }
}
