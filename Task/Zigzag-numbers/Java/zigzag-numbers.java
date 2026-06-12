import java.math.*;
import java.util.*;


public class ZigzagPermutations {

    /**
     * Check if the array has the zigzag property
     */
    public static boolean isZigzag(int[] arr) {
        if (arr == null || arr.length < 2) {
            return true;
        }

        for (int i = 0; i < arr.length - 1; i++) {
            if (i % 2 == 0) { // even index i
                if (arr[i] >= arr[i + 1]) {
                    return false;
                }
            } else { // odd index i
                if (arr[i] <= arr[i + 1]) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Mutates arr into the next permutation with the zigzag property.
     * Returns true if a new permutation was found, otherwise false.
     */
    public static boolean nextZigzagPerm(int[] arr) {
        while (true) {
            if (arr == null || arr.length <= 1) {
                break;
            }

            // Find last index where arr[i] < arr[i+1]
            int i = -1;
            for (int idx = 0; idx < arr.length - 1; idx++) {
                if (arr[idx] < arr[idx + 1]) {
                    i = idx;
                }
            }

            if (i == -1) {
                // Reverse the array
                reverseArray(arr, 0, arr.length - 1);
                break;
            }

            // Find last index where arr[j] > arr[i]
            int j = i + 1;
            for (int idx = i + 1; idx < arr.length; idx++) {
                if (arr[idx] > arr[i]) {
                    j = idx;
                }
            }

            // Swap elements at i and j
            swap(arr, i, j);

            // Reverse the subarray from i+1 to end
            reverseArray(arr, i + 1, arr.length - 1);

            if (isZigzag(arr)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Helper method to swap two elements in an array
     */
    private static void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    /**
     * Helper method to reverse a portion of an array
     */
    private static void reverseArray(int[] arr, int start, int end) {
        while (start < end) {
            swap(arr, start, end);
            start++;
            end--;
        }
    }

    /**
     * Lazy iterator to generate zigzag permutations of length n
     */
    public static class Zigzags implements Iterator<int[]> {
        private int n;
        private int[] state;
        private boolean hasNext;

        public Zigzags(int n) {
            this.n = n;
            this.state = new int[n];
            for (int i = 0; i < n; i++) {
                this.state[i] = i + 1;
            }
            this.hasNext = true;
        }

        @Override
        public boolean hasNext() {
            return hasNext;
        }

        @Override
        public int[] next() {
            if (!hasNext) {
                throw new NoSuchElementException();
            }

            int[] result = state.clone();
            hasNext = nextZigzagPerm(state);
            return result;
        }

        /**
         * Make this class iterable
         */
        public Iterable<int[]> asIterable() {
            return new Iterable<int[]>() {
                @Override
                public Iterator<int[]> iterator() {
                    return new Zigzags(n);
                }
            };
        }
    }

    /**
     * Generate zigzag permutation listings and print totals.
     */
    public static void testZigzags(int nListings, int nTotals) {
        // Generate zigzag permutation listings
        for (int n = 1; n <= nListings; n++) {
            System.out.println("\nZigZag Permutations for N = " + n + ":");
            if (n < 3) {
                System.out.print("[");
                for (int i = 1; i <= n; i++) {
                    System.out.print(i);
                    if (i < n) System.out.print(", ");
                }
                System.out.println("]");
            } else {
                Zigzags zigzags = new Zigzags(n);
                while (zigzags.hasNext()) {
                    int[] perm = zigzags.next();
                    System.out.print(Arrays.toString(perm) + " ");
                }
                System.out.println();
            }
        }

        // Calculate and print totals
        List<BigInteger> zzn = new ArrayList<>();
        zzn.add(BigInteger.ONE);

        System.out.println("\nN     Zigzags");
        System.out.println("--------------------------------");
        System.out.println(" 1    1");

        for (int m = 1; m < nTotals; m++) {
            List<BigInteger> cumsum = new ArrayList<>();
            BigInteger total = BigInteger.ZERO;

            if (m % 2 == 0) {
                // Reverse iteration
                for (int i = zzn.size() - 1; i >= 0; i--) {
                    total = total.add(zzn.get(i));
                    cumsum.add(total);
                }
                Collections.reverse(cumsum);
                zzn = new ArrayList<>(cumsum);
                zzn.add(BigInteger.ZERO);
            } else {
                for (BigInteger x : zzn) {
                    total = total.add(x);
                    cumsum.add(total);
                }
                zzn = new ArrayList<>();
                zzn.add(BigInteger.ZERO);
                zzn.addAll(cumsum);
            }

            BigInteger sum = zzn.stream().reduce(BigInteger.ZERO, BigInteger::add);
            System.out.printf("%2d    %s%n", m + 1, sum.toString());
        }
    }

    public static void main(String[] args) {
        testZigzags(5, 30);
    }
}
