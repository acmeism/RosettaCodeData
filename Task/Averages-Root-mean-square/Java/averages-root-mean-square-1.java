public class RootMeanSquare {

    public static double rootMeanSquare(double... nums) {
        double sum = 0.0;
        for (double num : nums)
            sum += num * num;
        return Math.sqrt(sum / nums.length);
    }

    public static void main(String[] args) {
        double[] nums = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0};
        System.out.println("The RMS of the numbers from 1 to 10 is " + rootMeanSquare(nums));
    }
}
