template <class T>
int binSearch(const T arr[], int len, T what) {
  int low = 0;
  int high = len - 1;
  while (low <= high) {
    int mid = (low + high) / 2;
    if (arr[mid] > what)
      high = mid - 1;
    else if (arr[mid] < what)
      low = mid + 1;
    else
      return mid;
  }
  return -1; // indicate not found
}
