/**
  Generic quicksort function using typescript generics.
  Follows quicksort as done in CLRS.
*/
export type Comparator<T> = (o1: T, o2: T) => number;


export function quickSort<T>(array: T[], compare: Comparator<T>) {
  if (array.length <= 1 || array == null) {
    return;
  }
  sort(array, compare, 0, array.length - 1);
}

function sort<T>(
    array: T[], compare: Comparator<T>, low: number, high: number) {
  if (low < high) {
    const partIndex = partition(array, compare, low, high);
    sort(array, compare, low, partIndex - 1);
    sort(array, compare, partIndex + 1, high);
  }
}

function partition<T>(
    array: T[], compare: Comparator<T>, low: number, high: number): number {
  const pivot: T = array[high];
  let i: number = low - 1;
  for (let j = low; j <= high - 1; j++) {
    if (compare(array[j], pivot) == -1) {
      i = i + 1;
      swap(array, i, j)
    }
  }
  if (compare(array[high], array[i + 1]) == -1) {
    swap(array, i + 1, high);
  }
  return i + 1;
}

function swap<T>(array: T[], i: number, j: number) {
  const newJ: T = array[i];
  array[i] = array[j];
  array[j] = newJ;
}

export function testQuickSort(): void {
  function numberComparator(o1: number, o2: number): number {
    if (o1 < o2) {
      return -1;
    } else if (o1 == o2) {
      return 0;
    }
    return 1;
  }
  let tests: number[][] = [
    [], [1], [2, 1], [-1, 2, -3], [3, 16, 8, -5, 6, 4], [1, 2, 3, 4, 5, 6],
    [1, 2, 3, 4, 5]
  ];

  for (let testArray of tests) {
    quickSort(testArray, numberComparator);
    console.log(testArray);
  }
}
