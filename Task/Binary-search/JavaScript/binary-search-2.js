function binary_search_iterative(a, value) {
  var mid, lo = 0,
      hi = a.length - 1;

  while (lo <= hi) {
    mid = Math.floor((lo + hi) / 2);

    if (a[mid] > value) {
      hi = mid - 1;
    } else if (a[mid] < value) {
      lo = mid + 1;
    } else {
      return mid;
    }
  }
  return null;
}
