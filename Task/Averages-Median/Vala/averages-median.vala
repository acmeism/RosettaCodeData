int compare_numbers(void* a_ref, void* b_ref) {
    double a = *(double*) a_ref;
    double b = *(double*) b_ref;
    return a > b ? 1 : a < b ? -1 : 0;
}

double median(double[] elements) {
    double[] clone = elements;
    Posix.qsort(clone, clone.length, sizeof(double), compare_numbers);
    double middle = clone.length / 2.0;
    int first = (int) Math.floor(middle);
    int second = (int) Math.ceil(middle);
    return (clone[first] + clone[second]) / 2;
}
void main() {
    double[] array1 = {2, 4, 6, 1, 7, 3, 5};
    double[] array2 = {2, 4, 6, 1, 7, 3, 5, 8};
    print(@"$(median(array1)) $(median(array2))\n");
}
