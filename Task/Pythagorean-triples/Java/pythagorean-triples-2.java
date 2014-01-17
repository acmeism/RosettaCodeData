import java.math.BigInteger;

public class Triples{
    public static BigInteger LIMIT;
    public static final BigInteger TWO = BigInteger.valueOf(2);
    public static final BigInteger THREE = BigInteger.valueOf(3);
    public static final BigInteger FOUR = BigInteger.valueOf(4);
    public static final BigInteger FIVE = BigInteger.valueOf(5);
    public static long primCount = 0;
    public static long tripCount = 0;

    //I don't know Japanese :p
    public static void parChild(BigInteger a, BigInteger b, BigInteger c){
        BigInteger perim = a.add(b).add(c);
        if(perim.compareTo(LIMIT) > 0) return;
        primCount++; tripCount += LIMIT.divide(perim).longValue();
        BigInteger a2 = TWO.multiply(a), b2 = TWO.multiply(b), c2 = TWO.multiply(c),
                   c3 = THREE.multiply(c);
        parChild(a.subtract(b2).add(c2),
                 a2.subtract(b).add(c2),
                 a2.subtract(b2).add(c3));
        parChild(a.add(b2).add(c2),
                 a2.add(b).add(c2),
                 a2.add(b2).add(c3));
        parChild(a.negate().add(b2).add(c2),
                 a2.negate().add(b).add(c2),
                 a2.negate().add(b2).add(c3));
    }

    public static void main(String[] args){
        for(long i = 100; i <= 10000000; i*=10){
            LIMIT = BigInteger.valueOf(i);
            primCount = tripCount = 0;
            parChild(THREE, FOUR, FIVE);
            System.out.println(LIMIT + ": " + tripCount + " triples, " + primCount + " primitive.");
        }
    }
}
