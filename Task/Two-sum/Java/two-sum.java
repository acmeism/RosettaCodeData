import java.util.Arrays;

public class TwoSum {

    public static void main(String[] args) {
        long sum = 21;
        int[] arr = {0, 2, 11, 19, 90};

        System.out.println(Arrays.toString(twoSum(arr, sum)));
    }

    public static int[] twoSum(int[] a, long target) {
        int i = 0, j = a.length - 1;
        while (i < j) {
            long sum = a[i] + a[j];
            if (sum == target)
                return new int[]{i, j};
            if (sum < target) i++;
            else j--;
        }
        return null;
    }
}
