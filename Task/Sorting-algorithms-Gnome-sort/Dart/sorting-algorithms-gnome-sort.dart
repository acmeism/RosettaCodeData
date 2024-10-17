void gnomeSort(List<int> arr) {
  int ub = arr.length - 1;
  int i = 0 + 1;
  int j = 0 + 2;

  while (i <= ub) {
    if (arr[i - 1] <= arr[i]) {
      i = j;
      j++;
    } else {
      int temp = arr[i - 1];
      arr[i - 1] = arr[i];
      arr[i] = temp;
      i--;
      if (i == 0) {
        i = j;
        j++;
      }
    }
  }
}

void main() {
  List<int> array = [-7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7];
  array.shuffle(); // Unsort the array

  print("unsort: $array");
  gnomeSort(array); // Sort the array
  print("  sort: $array");
}
