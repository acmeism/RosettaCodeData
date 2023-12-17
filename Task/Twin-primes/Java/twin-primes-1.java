import java.math.BigInteger;
import java.util.Scanner;

public class twinPrimes {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        System.out.println("Search Size: ");
        BigInteger max = input.nextBigInteger();
        int counter = 0;
        for(BigInteger x = new BigInteger("3"); x.compareTo(max) <= 0; x = x.add(BigInteger.ONE)){
            BigInteger sqrtNum = x.sqrt().add(BigInteger.ONE);
            if(x.add(BigInteger.TWO).compareTo(max) <= 0) {
                counter += findPrime(x.add(BigInteger.TWO), x.add(BigInteger.TWO).sqrt().add(BigInteger.ONE)) && findPrime(x, sqrtNum) ? 1 : 0;
            }
        }
        System.out.println(counter + " twin prime pairs.");
    }
    public static boolean findPrime(BigInteger x, BigInteger sqrtNum){
        for(BigInteger divisor = BigInteger.TWO; divisor.compareTo(sqrtNum) <= 0; divisor = divisor.add(BigInteger.ONE)){
            if(x.remainder(divisor).compareTo(BigInteger.ZERO) == 0){
                return false;
            }
        }
        return true;
    }
}
