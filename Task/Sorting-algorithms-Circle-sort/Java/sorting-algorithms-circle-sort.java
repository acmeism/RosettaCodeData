import java.util.Arrays;

public class CircleSort {

    public static void main(String[] args) {
        circleSort(new int[]{2, 14, 4, 6, 8, 1, 3, 5, 7, 11, 0, 13, 12, -1});
    }

    public static void circleSort(int[] arr) {
        if (arr.length > 0)
            do {
                System.out.println(Arrays.toString(arr));
            } while (circleSortR(arr, 0, arr.length - 1, 0) != 0);
    }

    private static int circleSortR(int[] arr, int lo, int hi, int numSwaps) {
        if (lo == hi)
            return numSwaps;

        int high = hi;
        int low = lo;
        int mid = (hi - lo) / 2;

        while (lo < hi) {
            if (arr[lo] > arr[hi]) {
                swap(arr, lo, hi);
                numSwaps++;
            }
            lo++;
            hi--;
        }

        if (lo == hi && arr[lo] > arr[hi + 1]) {
            swap(arr, lo, hi + 1);
            numSwaps++;
        }

        numSwaps = circleSortR(arr, low, low + mid, numSwaps);
        numSwaps = circleSortR(arr, low + mid + 1, high, numSwaps);

        return numSwaps;
    }

    private static void swap(int[] arr, int idx1, int idx2) {
        int tmp = arr[idx1];
        arr[idx1] = arr[idx2];
        arr[idx2] = tmp;
    }
}
