import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.function.Predicate;

public class WaveletMatrixDemo {
    // BitRank is a rank data structure for bit vectors
    static class BitRank {
        private long[] block;
        private int[] count;

        // Resize resizes the bit vector to the given length
        public void resize(int num) {
            block = new long[((num + 1) >> 6) + 1];
            count = new int[block.length];
        }

        // Set sets bit at position i
        public void set(int i, int val) {
            if (val == 1) {
                block[i >> 6] |= (1L << (i & 63));
            }
        }

        // Build builds the rank structure
        public void build() {
            for (int i = 1; i < block.length; i++) {
                count[i] = count[i - 1] + popcountll(block[i - 1]);
            }
        }

        // popcountll counts number of 1's in a 64-bit integer
        private int popcountll(long n) {
            return Long.bitCount(n);
        }

        // Rank1 counts number of 1's in [0, i)
        public int rank1(int i) {
            return count[i >> 6] + popcountll(block[i >> 6] & ((1L << (i & 63)) - 1));
        }

        // Rank1FromTo counts number of 1's in [i, j)
        public int rank1FromTo(int i, int j) {
            return rank1(j) - rank1(i);
        }

        // Rank0 counts number of 0's in [0, i)
        public int rank0(int i) {
            return i - rank1(i);
        }

        // Rank0FromTo counts number of 0's in [i, j)
        public int rank0FromTo(int i, int j) {
            return rank0(j) - rank0(i);
        }
    }

    // WaveletMatrix is a wavelet matrix data structure
    static class WaveletMatrix {
        private int height;
        private BitRank[] B;
        private int[] pos;

        // Constructor creates a new wavelet matrix
        public WaveletMatrix(int[] vec, int... sigma) {
            int s = 0;
            if (sigma.length > 0) {
                s = sigma[0];
            } else {
                // Find the maximum element and use that as sigma
                for (int v : vec) {
                    if (v > s) {
                        s = v;
                    }
                }
                s++;
            }

            init(vec, s);
        }

        private void init(int[] vec, int sigma) {
            // Calculate height based on sigma value
            if (sigma == 1) {
                height = 1;
            } else {
                height = 64 - Long.numberOfLeadingZeros(sigma - 1);
            }

            B = new BitRank[height];
            pos = new int[height];

            for (int i = 0; i < height; i++) {
                B[i] = new BitRank();
                B[i].resize(vec.length);

                for (int j = 0; j < vec.length; j++) {
                    B[i].set(j, get(vec[j], height - i - 1));
                }

                B[i].build();

                // Use a final variable to capture the current i value
                final int currentLevel = i;
                pos[i] = stablePartition(vec, c -> get(c, height - currentLevel - 1) == 0);
            }
        }

        // stablePartition is equivalent to C++ stable_partition
        private int stablePartition(int[] arr, Predicate<Integer> predicate) {
            List<Integer> result = new ArrayList<>(arr.length);
            List<Integer> falseValues = new ArrayList<>(arr.length);

            for (int item : arr) {
                if (predicate.test(item)) {
                    result.add(item);
                } else {
                    falseValues.add(item);
                }
            }

            int partitionPoint = result.size();
            result.addAll(falseValues);

            // Update the original array
            for (int i = 0; i < result.size(); i++) {
                arr[i] = result.get(i);
            }

            return partitionPoint;
        }

        // get returns bit at position i from val
        private int get(int val, int i) {
            return (val >> i) & 1;
        }

        // Rank counts occurrences of val in range [l, r)
        public int rank(int val, int l, int r) {
            return rankSingle(val, r) - rankSingle(val, l);
        }

        // RankSingle counts occurrences of val in range [0, i)
        public int rankSingle(int val, int i) {
            int p = 0;
            for (int j = 0; j < height; j++) {
                if (get(val, height - j - 1) == 1) {
                    p = pos[j] + B[j].rank1(p);
                    i = pos[j] + B[j].rank1(i);
                } else {
                    p = B[j].rank0(p);
                    i = B[j].rank0(i);
                }
            }
            return i - p;
        }

        // Quantile returns kth smallest element in [l, r)
        public int quantile(int k, int l, int r) {
            int res = 0;
            for (int i = 0; i < height; i++) {
                int j = B[i].rank0FromTo(l, r);
                if (j > k) {
                    l = B[i].rank0(l);
                    r = B[i].rank0(r);
                } else {
                    l = pos[i] + B[i].rank1(l);
                    r = pos[i] + B[i].rank1(r);
                    k -= j;
                    res |= (1 << (height - i - 1));
                }
            }
            return res;
        }

        // RangeFreq counts elements in [l, r) that are in value range [a, b)
        public int rangeFreq(int l, int r, int a, int b) {
            return rangeFreqRecursive(l, r, a, b, 0, 1 << height, 0);
        }

        private int rangeFreqRecursive(int i, int j, int a, int b, int l, int r, int x) {
            if (i == j || r <= a || b <= l) {
                return 0;
            }

            int mid = (l + r) >> 1;
            if (a <= l && r <= b) {
                return j - i;
            } else {
                int left = rangeFreqRecursive(
                        B[x].rank0(i),
                        B[x].rank0(j),
                        a, b, l, mid, x + 1
                );
                int right = rangeFreqRecursive(
                        pos[x] + B[x].rank1(i),
                        pos[x] + B[x].rank1(j),
                        a, b, mid, r, x + 1
                );
                return left + right;
            }
        }

        // RangeMin finds minimum value in [l, r) within value range [a, b), -1 if not found
        public int rangeMin(int l, int r, int a, int b) {
            return rangeMinRecursive(l, r, a, b, 0, 1 << height, 0, 0);
        }

        private int rangeMinRecursive(int i, int j, int a, int b, int l, int r, int x, int val) {
            if (i == j || r <= a || b <= l) {
                return -1;
            }
            if (r - l == 1) {
                return val;
            }

            int mid = (l + r) >> 1;
            int res = rangeMinRecursive(
                    B[x].rank0(i),
                    B[x].rank0(j),
                    a, b, l, mid, x + 1, val
            );

            if (res < 0) {
                return rangeMinRecursive(
                        pos[x] + B[x].rank1(i),
                        pos[x] + B[x].rank1(j),
                        a, b, mid, r, x + 1,
                        val + (1 << (height - x - 1))
                );
            } else {
                return res;
            }
        }
    }

    // binary search to find index in sorted array
    private static int find(int[] arr, int x) {
        int left = 0;
        int right = arr.length;
        while (left < right) {
            int mid = (left + right) / 2;
            if (arr[mid] < x) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        return left;
    }

    public static void main(String[] args) {
        int n = 5;
        int[] a = {3374, 956, 2114, 3415, 3437};

        int[] input = Arrays.copyOf(a, n);
        int[] backup = Arrays.copyOf(a, n);

        // Sort and deduplicate the array
        int[] sortedA = Arrays.copyOf(a, n);
        Arrays.sort(sortedA);

        // Deduplicate
        List<Integer> uniqueAList = new ArrayList<>();
        for (int i = 0; i < sortedA.length; i++) {
            if (i == 0 || sortedA[i] != sortedA[i - 1]) {
                uniqueAList.add(sortedA[i]);
            }
        }

        // Convert List to array
        int[] uniqueA = new int[uniqueAList.size()];
        for (int i = 0; i < uniqueAList.size(); i++) {
            uniqueA[i] = uniqueAList.get(i);
        }

        // Map original values to their indices in the unique array
        for (int i = 0; i < n; i++) {
            input[i] = find(uniqueA, backup[i]);
        }

        int[][] lrkVector = {
                {2, 2, 1},
                {3, 4, 1},
                {4, 5, 1},
                {1, 2, 2},
                {4, 4, 1}
        };

        WaveletMatrix wm = new WaveletMatrix(input);

        for (int[] lrk : lrkVector) {
            int l = lrk[0];
            int r = lrk[1];
            int k = lrk[2];
            l--; // Convert to 0-indexed
            System.out.println(uniqueA[wm.quantile(k - 1, l, r)]);
        }
    }
}
