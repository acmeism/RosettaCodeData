class SelectionSort {
  @:generic
  public static function sort<T>(arr:Array<T>) {
    var len = arr.length;
    for (index in 0...len) {
      var minIndex = index;
      for (remainingIndex in (index+1)...len) {
        if (Reflect.compare(arr[minIndex], arr[remainingIndex]) > 0)
          minIndex = remainingIndex;
      }
      if (index != minIndex) {
        var temp = arr[index];
        arr[index] = arr[minIndex];
        arr[minIndex] = temp;
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
    Sys.println('Unsorted Integers:' + integerArray);
    SelectionSort.sort(integerArray);
    Sys.println('Sorted Integers:  ' + integerArray);
    Sys.println('Unsorted Floats:  ' + floatArray);
    SelectionSort.sort(floatArray);
    Sys.println('Sorted Floats:    ' + floatArray);
    Sys.println('Unsorted Strings: ' + stringArray);
    SelectionSort.sort(stringArray);
    Sys.println('Sorted Strings:   ' + stringArray);
  }
}
