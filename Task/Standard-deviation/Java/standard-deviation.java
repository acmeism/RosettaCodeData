public class StdDev {
    int n = 0;
    double sum = 0;
    double sum2 = 0;

    public double sd(double x) {
	n++;
	sum += x;
	sum2 += x*x;

	return Math.sqrt(sum2/n - sum*sum/n/n);
    }

    public static void main(String[] args) {
        double[] testData = {2,4,4,4,5,5,7,9};
        StdDev sd = new StdDev();

        for (double x : testData) {
            System.out.println(sd.sd(x));
        }
    }
}
