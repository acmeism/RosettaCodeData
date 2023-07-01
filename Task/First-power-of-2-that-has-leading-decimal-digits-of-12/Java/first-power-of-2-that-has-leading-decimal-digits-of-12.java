public class FirstPowerOfTwo {

    public static void main(String[] args) {
        runTest(12, 1);
        runTest(12, 2);
        runTest(123, 45);
        runTest(123, 12345);
        runTest(123, 678910);
    }

    private static void runTest(int l, int n) {
        System.out.printf("p(%d, %d) = %,d%n", l, n, p(l, n));
    }

    public static int p(int l, int n) {
        int test = 0;
        double log = Math.log(2) / Math.log(10);
        int factor = 1;
        int loop = l;
        while ( loop > 10 ) {
            factor *= 10;
            loop /= 10;
        }
        while ( n > 0) {
            test++;
            int val = (int) (factor * Math.pow(10, test * log % 1));
            if ( val == l ) {
                n--;
            }
        }
        return test;
    }

}
