public class MainApp {
    public static void main(String[] args) {
        int countOfPrimes = 0;
        final int targetCountOfPrimes = 10;
        long f = 1;
        while (countOfPrimes < targetCountOfPrimes) {
            long factorialNum = getFactorial(f);
            boolean primePlus = isPrime(factorialNum + 1);
            boolean primeMinus = isPrime(factorialNum - 1);
            if (primeMinus) {
                countOfPrimes++;
                System.out.println(countOfPrimes + ": " + factorialNum + "! - 1 = " + (factorialNum - 1));

            }
            if (primePlus  && f > 1) {
                countOfPrimes++;
                System.out.println(countOfPrimes + ": " + factorialNum + "! + 1 = " + (factorialNum + 1));
            }
            f++;
        }
    }

    private static long getFactorial(long f) {
        long factorial = 1;
        for (long i = 1; i < f; i++) {
            factorial *= i;
        }
        return factorial;
    }

    private static boolean isPrime(long num) {
        if (num < 2) {return false;}
        for (long i = 2; i < num; i++) {
            if (num % i == 0) {return false;}
        }
        return true;
    }
}
