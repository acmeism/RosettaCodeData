import java.math.BigInteger;
import java.util.Random;

public class rsaCode {
    public static void main(String[]args){
        //Size of primes
        int BIT_LENGTH = 4096;
        Random rand = new Random();
        //Generate primes and other necessary values
        BigInteger p = BigInteger.probablePrime(BIT_LENGTH / 2, rand);
        BigInteger q = BigInteger.probablePrime(BIT_LENGTH / 2, rand);
        BigInteger n = p.multiply(q);
        BigInteger phi = p.subtract(BigInteger.valueOf(1)).multiply(q.subtract(BigInteger.valueOf(1)));
        BigInteger e;
        BigInteger d;
        do {
            e = new BigInteger(phi.bitLength(), rand);
        } while (e.compareTo(BigInteger.valueOf(1)) <= 0 || e.compareTo(phi) >= 0 || !e.gcd(phi).equals(BigInteger.valueOf(1)));
        d = e.modInverse(phi);
        //Convert message to byte array and then to a BigInteger
        BigInteger message = new BigInteger("Hello World! - From Rosetta Code".getBytes());
        BigInteger cipherText = message.modPow(e, n);
        BigInteger decryptedText = cipherText.modPow(d, n);
        System.out.println("Message: " + message);
        System.out.println("Prime 1: " + p);
        System.out.println("Prime 2: " + q);
        System.out.println("Phi p1 * p2: " + phi);
        System.out.println("p1 * p2: " + n);
        System.out.println("Public key: " + e);
        System.out.println("Private key: " + d);
        System.out.println("Ciphertext: " + cipherText);
        System.out.println("Decrypted message(number form): " + decryptedText);
        //Convert BigInteger to byte array then to String
        System.out.println("Decrypted message(string): " + new String(decryptedText.toByteArray()));
    }
}
