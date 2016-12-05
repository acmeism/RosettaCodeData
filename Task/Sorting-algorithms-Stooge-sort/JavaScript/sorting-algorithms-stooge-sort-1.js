function stoogeSort (array, i, j) {
    if (j === undefined) {
        j = array.length - 1;
    }

    if (i === undefined) {
        i = 0;
    }

    if (array[j] < array[i]) {
        var aux = array[i];
        array[i] = array[j];
        array[j] = aux;
    }

    if (j - i > 1) {
        var t = Math.floor((j - i + 1) / 3);
        stoogeSort(array, i, j-t);
        stoogeSort(array, i+t, j);
        stoogeSort(array, i, j-t);
    }
};
