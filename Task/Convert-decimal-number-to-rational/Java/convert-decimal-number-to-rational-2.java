import org.apache.commons.math3.fraction.BigFraction;

public class Test {

    public static void main(String[] args) {
        double[] n = {0.750000000, 0.518518000, 0.905405400, 0.142857143,
            3.141592654, 2.718281828, -0.423310825, 31.415926536};

        for (double d : n)
            System.out.printf("%-12s : %s%n", d, new BigFraction(d, 0.00000002D, 10000));
    }
}
