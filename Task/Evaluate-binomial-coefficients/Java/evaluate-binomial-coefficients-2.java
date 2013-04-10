public class Binom {
    public static double binomCoeff(double n, double k) {
        double result = 1;
        for (int i = 1; i < k + 1; i++) {
            result *= (n - i + 1) / i;
        }
        return result;
    }

    public static void main(String[] args) {
        System.out.println(binomCoeff(5, 3));
    }
}
