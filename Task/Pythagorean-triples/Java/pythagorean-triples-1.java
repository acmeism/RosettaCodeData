import java.math.BigInteger;
import static java.math.BigInteger.ONE;

public class PythTrip{

    public static void main(String[] args){
        long tripCount = 0, primCount = 0;

        //change this to whatever perimeter limit you want;the RAM's the limit
        BigInteger periLimit = BigInteger.valueOf(100),
                peri2 = periLimit.divide(BigInteger.valueOf(2)),
                peri3 = periLimit.divide(BigInteger.valueOf(3));

        for(BigInteger a = ONE; a.compareTo(peri3) < 0; a = a.add(ONE)){
            BigInteger aa = a.multiply(a);

            for(BigInteger b = a.add(ONE);
                    b.compareTo(peri2) < 0; b = b.add(ONE)){
                BigInteger bb = b.multiply(b);
                BigInteger ab = a.add(b);
                BigInteger aabb = aa.add(bb);

                for(BigInteger c = b.add(ONE);
                        c.compareTo(peri2) < 0; c = c.add(ONE)){

                    int compare = aabb.compareTo(c.multiply(c));
                    //if a+b+c > periLimit
                    if(ab.add(c).compareTo(periLimit) > 0){
                        break;
                    }
                    //if a^2 + b^2 != c^2
                    if(compare < 0){
                        break;
                    }else if (compare == 0){
                        tripCount++;
                        System.out.print(a + ", " + b + ", " + c);

                        //does binary GCD under the hood
                        if(a.gcd(b).equals(ONE)){
                            System.out.print(" primitive");
                            primCount++;
                        }
                        System.out.println();
                    }
                }
            }
        }
        System.out.println("Up to a perimeter of " + periLimit + ", there are "
                + tripCount + " triples, of which " + primCount + " are primitive.");
    }
}
