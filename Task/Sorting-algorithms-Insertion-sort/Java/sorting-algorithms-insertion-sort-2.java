public static <E extends Comparable<? super E>> void insertionSort(List<E> a) {
  for (int i = 1; i < a.size(); i++) {
    int j = Math.abs(Collections.binarySearch(a.subList(0, i), a.get(i)) + 1);
    Collections.rotate(a.subList(j, i+1), j - i);
  }
}
public static <E extends Comparable<? super E>> void insertionSort(E[] a) {
  for (int i = 1; i < a.length; i++) {
    E x = a[i];
    int j = Math.abs(Arrays.binarySearch(a, 0, i, x) + 1);
    System.arraycopy(a, j, a, j+1, i-j);
    a[j] = x;
  }
}
