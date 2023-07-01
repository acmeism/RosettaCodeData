void main() {
    List<int> a = shellSort([1100, 2, 56, 200, -52, 3, 99, 33, 177, -199]);
    print('$a');
}

shellSort(List<int> array) {
	int n = array.length;

        // Start with a big gap, then reduce the gap
        for (int gap = n~/2; gap > 0; gap ~/= 2)
        {
            // Do a gapped insertion sort for this gap size.
            // The first gap elements a[0..gap-1] are already
            // in gapped order keep adding one more element
            // until the entire array is gap sorted
            for (int i = gap; i < n; i += 1)
            {
                // add a[i] to the elements that have been gap
                // sorted save a[i] in temp and make a hole at
                // position i
                int temp = array[i];

                // shift earlier gap-sorted elements up until
                // the correct location for a[i] is found
                int j;
                for (j = i; j >= gap && array[j - gap] > temp; j -= gap)
                    array[j] = array[j - gap];

                // put temp (the original a[i]) in its correct
                // location
                array[j] = temp;
            }
        }
  return array;
}
