void swap(int[] array, int i1, int i2) {
  if (array[i1] == array[i2])
    return;
  var tmp = array[i1];
  array[i1] = array[i2];
  array[i2] = tmp;
}

void cocktail_sort(int[] array) {
  while(true) {
    bool flag = false;
    int[] start = {1, array.length - 1};
    int[] end = {array.length, 0};
    int[] inc = {1, -1};
    for (int it = 0; it < 2; ++it) {
      flag = true;
      for (int i = start[it]; i != end[it]; i += inc[it])
	if (array[i - 1] > array[i]) {
	  swap(array, i - 1, i);
          flag = false;
	}
    }
    if (flag) return;
  }
}

void main() {
  int[] array = {5, -1, 101, -4, 0, 1, 8, 6, 2, 3};
  cocktail_sort(array);
  foreach (int i in array) {
    stdout.printf("%d ", i);
  }
}
