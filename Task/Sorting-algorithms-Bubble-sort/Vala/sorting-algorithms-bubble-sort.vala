void swap(int[] array, int i1, int i2) {
  if (array[i1] == array[i2])
    return;
  var tmp = array[i1];
  array[i1] = array[i2];
  array[i2] = tmp;
}

void bubble_sort(int[] array) {
  bool flag = true;
  int j = array.length;
  while(flag) {
    flag = false;
    for (int i = 1; i < j; i++) {
      if (array[i] < array[i - 1]) {
        swap(array, i - 1, i);
        flag = true;
      }
    }
    j--;
  }
}

void main() {
  int[] array = {5, -1, 101, -4, 0, 1, 8, 6, 2, 3};
  bubble_sort(array);
  foreach (int i in array)
    print("%d ", i);
}
