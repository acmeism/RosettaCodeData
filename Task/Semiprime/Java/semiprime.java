import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public class SemiPrime{
	private static final BigInteger TWO = BigInteger.valueOf(2);
	
	public static List<BigInteger> primeDecomp(BigInteger a){
	    // impossible for values lower than 2
	    if(a.compareTo(TWO) < 0){
	        return null;
	    }
	
	    //quickly handle even values
	    List<BigInteger> result = new ArrayList<BigInteger>();
	    while(a.and(BigInteger.ONE).equals(BigInteger.ZERO)){
	        a = a.shiftRight(1);
	        result.add(TWO);
	    }
	
	    //left with odd values
	    if(!a.equals(BigInteger.ONE)){
	        BigInteger b = BigInteger.valueOf(3);
	        while(b.compareTo(a) < 0){
	            if(b.isProbablePrime(10)){
	                BigInteger[] dr = a.divideAndRemainder(b);
	                if(dr[1].equals(BigInteger.ZERO)){
	                    result.add(b);
	                    a = dr[0];
	                }
	            }
	            b = b.add(TWO);
	        }
	        result.add(b); //b will always be prime here...
	    }
	    return result;
	}
	
	public static boolean isSemi(BigInteger x){
		List<BigInteger> decomp = primeDecomp(x);
		return decomp != null && decomp.size() == 2;
	}
	
	public static void main(String[] args){
		for(int i = 2; i <= 100; i++){
			if(isSemi(BigInteger.valueOf(i))){
				System.out.print(i + " ");
			}
		}
		System.out.println();
		for(int i = 1675; i <= 1680; i++){
			if(isSemi(BigInteger.valueOf(i))){
				System.out.print(i + " ");
			}
		}
	}
}
