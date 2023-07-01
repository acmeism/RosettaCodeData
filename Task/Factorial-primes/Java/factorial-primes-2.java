import java.math.BigInteger;

public class MainApp {
    public static void main(String[] args) {
        //Used to measure total runtime of program.
        long starttime = System.nanoTime();
        //How many primes found, how many primes wanted, loop counter.
        int countOfPrimes = 0;
        final int targetCountOfPrimes = 30;
        long f = 1;
        //Starting BigInteger at 1.
        BigInteger biFactorial = BigInteger.ONE;
        while (countOfPrimes < targetCountOfPrimes) {
            //Each loop, multiply the number by the loop
            //counter (f) to increase factorial much more quickly.
            biFactorial = biFactorial.multiply(BigInteger.valueOf(f));
            // one less than the factorial.
            BigInteger biMinusOne = biFactorial.subtract(BigInteger.ONE);
            // one more than the factorial.
            BigInteger biPlusOne = biFactorial.add(BigInteger.ONE);

            //Determine if the numbers are prime with a probability of 100
            boolean primeMinus = biMinusOne.isProbablePrime(100);
            boolean primePlus = biPlusOne.isProbablePrime(100);

            //Make the big number look like a pretty string for output.
            String biMinusOneString = convert(biMinusOne);
            String biPlusOneString = convert(biPlusOne);

            //If the number was prime, output and increment the primt counter.
            if (primeMinus) {
                countOfPrimes++;
                System.out.println(
                        countOfPrimes + ": " + f + "! - 1 = " + biMinusOneString);
            }
            if (primePlus) {
                countOfPrimes++;
                System.out.println(countOfPrimes + ": " + f + "! + 1 = " + biPlusOneString);
            }
            //Increment loop counter.
            f++;
        }
        //Calculate and display program runtime.
        long stoptime = System.nanoTime();
        long runtime = stoptime - starttime;
        System.out.println("Program runtime: " + runtime + " ns (~" + runtime/1_000_000_000 + " seconds)");
    }

    //Method to make output pretty
    private static String convert(BigInteger bi) {
        String s = bi.toString();
        int l = s.length();
        String s2 = "";
        if (l >= 40) {
            s2 = s.substring(0, 19);
            s2 += "..." + s.substring(s.length() - 20, s.length());
            s2 += " : " + l + " digits";
        } else {s2 = s;}
        return s2;
    }
}
