void insertion_sort(int[] array) {
  var count = 0;
  for (int i = 1; i < array.length; i++) {
    var val = array[i];
    var j = i;
    while (j > 0 && val < array[j - 1]) {
      array[j] = array[j - 1];
      j--;
    }
    array[j] = val;
  }
}

void main() {
  int[] array = {4, 65, 2, -31, 0, 99, 2, 83, 782};
  insertion_sort(array);
  foreach (int i in array)
    print("%d ", i);
}
