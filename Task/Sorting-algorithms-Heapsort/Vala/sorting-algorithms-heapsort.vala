void swap(int[] array, int i1, int i2) {
  if (array[i1] == array[i2])
    return;
  var tmp = array[i1];
  array[i1] = array[i2];
  array[i2] = tmp;
}

void shift_down(int[] heap, int i, int max) {
  int i_big, c1, c2;
  while (i < max) {
    i_big = i;
    c1 = (2 * i) + 1;
    c2 = c1 + 1;
    if (c1 < max && heap[c1] > heap[i_big])
      i_big = c1;
    if (c2 < max && heap[c2] > heap[i_big])
      i_big = c2;
    if (i_big == i) return;
    swap(heap, i, i_big);
    i = i_big;
  }
}

void to_heap(int[] array) {
  int i = (array.length / 2) - 1;
  while (i >= 0) {
    shift_down(array, i, array.length);
    --i;
  }
}

void heap_sort(int[] array) {
  to_heap(array);
  int end = array.length - 1;
  while (end > 0) {
    swap(array, 0, end);
    shift_down(array, 0, end);
    --end;
  }
}

void main() {
  int[] data = {
    12, 11, 15, 10,  9,
     1,  2, 13,  3, 14,
     4,  5,  6,  7,  8
  };
  heap_sort(data);
  foreach (int i in data) {
    stdout.printf("%d ", i);
  }
}
