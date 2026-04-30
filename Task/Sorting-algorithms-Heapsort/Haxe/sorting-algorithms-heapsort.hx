class HeapSort {
  @:generic
  private static function siftDown<T>(arr: Array<T>, start:Int, end:Int) {
    var root = start;
    while (root * 2 + 1 <= end) {
      var child = root * 2 + 1;
      if (child + 1 <= end && Reflect.compare(arr[child], arr[child + 1]) < 0)
        child++;
      if (Reflect.compare(arr[root], arr[child]) < 0) {
        var temp = arr[root];
        arr[root] = arr[child];
        arr[child] = temp;
        root = child;
      } else {
        break;
      }
    }
  }

  @:generic
  public static function sort<T>(arr:Array<T>) {
    if (arr.length > 1)
    {
      var start = (arr.length - 2) >> 1;
      while (start > 0) {
        siftDown(arr, start - 1, arr.length - 1);
        start--;
      }
    }

    var end = arr.length - 1;
    while (end > 0) {
      var temp = arr[end];
      arr[end] = arr[0];
      arr[0] = temp;
      siftDown(arr, 0, end - 1);
      end--;
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
    HeapSort.sort(integerArray);
    Sys.println('Sorted Integers:   ' + integerArray);
    Sys.println('Unsorted Floats:   ' + floatArray);
    HeapSort.sort(floatArray);
    Sys.println('Sorted Floats:     ' + floatArray);
    Sys.println('Unsorted Strings:  ' + stringArray);
    HeapSort.sort(stringArray);
    Sys.println('Sorted Strings:    ' + stringArray);
  }
}
