function sort(array, less) {

  function swap(i, j) { var t=array[i]; array[i]=array[j]; array[j]=t }

  function quicksort(left, right) {

    if (left < right) {

      var pivot = array[(left + right) >> 1];
      var left_new = left, right_new = right;

      do {
        while (less(array[left_new], pivot)
          left_new++;
        while (less(pivot, array[right_new])
          right_new--;
        if (left_new  <= right_new)
          swap(left_new++, right_new--);
      } while (left_new  <= right_new);

      quicksort(left, right_new);
      quicksort(left_new, right);

    }
  }

  quicksort(0, array.length-1);

  return array;
}
