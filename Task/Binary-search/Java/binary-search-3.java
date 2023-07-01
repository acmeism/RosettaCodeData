import java.util.Arrays;

int index = Arrays.binarySearch(array, thing);
int index = Arrays.binarySearch(array, startIndex, endIndex, thing);

// for objects, also optionally accepts an additional comparator argument:
int index = Arrays.binarySearch(array, thing, comparator);
int index = Arrays.binarySearch(array, startIndex, endIndex, thing, comparator);
