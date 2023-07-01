public class RangeExtraction {

    public static void main(String[] args) {
        int[] arr = {0, 1, 2, 4, 6, 7, 8, 11, 12, 14,
            15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
            25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
            37, 38, 39};

        int len = arr.length;
        int idx = 0, idx2 = 0;
        while (idx < len) {
            while (++idx2 < len && arr[idx2] - arr[idx2 - 1] == 1);
            if (idx2 - idx > 2) {
                System.out.printf("%s-%s,", arr[idx], arr[idx2 - 1]);
                idx = idx2;
            } else {
                for (; idx < idx2; idx++)
                    System.out.printf("%s,", arr[idx]);
            }
        }
    }
}
