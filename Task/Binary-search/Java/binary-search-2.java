public class BinarySearchRecursive {

    public static int binarySearch(int[] haystack, int needle, int lo, int hi) {
        if (hi < lo) {
            return -1;
        }
        int guess = (hi + lo) / 2;
        if (haystack[guess] > needle) {
            return binarySearch(haystack, needle, lo, guess - 1);
        } else if (haystack[guess] < needle) {
            return binarySearch(haystack, needle, guess + 1, hi);
        }
        return guess;
    }

    public static void main(String[] args) {
        int[] haystack = {1, 5, 6, 7, 8, 11};
        int needle = 5;

        int index = binarySearch(haystack, needle, 0, haystack.length);

        if (index == -1) {
            System.out.println(needle + " is not in the array");
        } else {
            System.out.println(needle + " is at index " + index);
        }
    }
}
