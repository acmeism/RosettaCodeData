import java.math.BigInteger;

public class LongMult {
	
	public static void main(String[] args) {
		BigInteger TwoPow64 = new BigInteger("18446744073709551616");
		System.out.println(mult(TwoPow64, TwoPow64));
	}

	public static BigInteger mult(BigInteger a, BigInteger b){
		return a.multiply(b);
	}
}
