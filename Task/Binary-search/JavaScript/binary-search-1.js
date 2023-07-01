function binary_search_recursive(a, value, lo, hi) {
  if (hi < lo) { return null; }

  var mid = Math.floor((lo + hi) / 2);

  if (a[mid] > value) {
    return binary_search_recursive(a, value, lo, mid - 1);
  }
  if (a[mid] < value) {
    return binary_search_recursive(a, value, mid + 1, hi);
  }
  return mid;
}
