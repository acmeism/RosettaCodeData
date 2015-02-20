import java.math.BigInteger;

public class LeftFac{
	public static BigInteger factorial(BigInteger n){
		BigInteger ans = BigInteger.ONE;
		for(BigInteger x = BigInteger.ONE; x.compareTo(n) <= 0; x = x.add(BigInteger.ONE)){
			ans = ans.multiply(x);
		}
		return ans;
	}
	
	public static BigInteger leftFact(BigInteger n){
		BigInteger ans = BigInteger.ZERO;
		for(BigInteger k = BigInteger.ZERO; k.compareTo(n.subtract(BigInteger.ONE)) <= 0; k = k.add(BigInteger.ONE)){
			ans = ans.add(factorial(k));
		}
		return ans;
	}
	
	public static void main(String[] args){
		for(int i = 0; i <= 10; i++){
			System.out.println("!" + i + " = " + leftFact(BigInteger.valueOf(i)));
		}
		
		for(int i = 20; i <= 110; i += 10){
			System.out.println("!" + i + " = " + leftFact(BigInteger.valueOf(i)));
		}
		
		for(int i = 1000; i <= 10000; i += 1000){
			System.out.println("!" + i + " has " + leftFact(BigInteger.valueOf(i)).toString().length() + " digits");
		}
	}
}
