class CountingSort {
  public static function sort(arr:Array<Int>) {
    var min = arr[0], max = arr[0];
    for (i in 1...arr.length) {
      if (arr[i] < min)
        min = arr[i];
      else if (arr[i] > max)
        max = arr[i];
    }

    var range = max - min + 1;
    var count = new Array<Int>();
    count.resize(range * arr.length);

    for (i in 0...range) count[i] = 0;
    for (i in 0...arr.length) count[arr[i] - min]++;

    var z = 0;
    for (i in min...(max + 1)) {
      for (j in 0...count[i - min])
        arr[z++] = i;
    }
  }
}

class Main {
  static function main() {
    var integerArray = [1, 10, 2, 5, -1, 5, -19, 4, 23, 0];
    Sys.println('Unsorted Integers: ' + integerArray);
    CountingSort.sort(integerArray);
    Sys.println('Sorted Integers:   ' + integerArray);
  }
}
