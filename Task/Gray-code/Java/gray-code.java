import java.math.BigInteger;

public class GrayCode {
	
	public static long grayEncode(long n){
		return n ^ ( n >>> 1 );
	}
	
	public static long grayDecode(long n) {
		long p = n;
		while ( ( n >>>= 1 ) != 0 ) {
			p ^= n;
		}
		return p;
	}
	
	public static BigInteger grayEncode(BigInteger n) {
		return n.xor(n.shiftRight(1));
	}
	
	public static BigInteger grayDecode(BigInteger n) {
		BigInteger p = n;
		while ( ( n = n.shiftRight(1) ).signum() != 0 ) {
			p = p.xor(n);
		}
		return p;
	}
	
	/**
	 * An alternative version of grayDecode,
	 * less efficient, but demonstrates the principal of gray decoding.
	 */
	public static BigInteger grayDecode2(BigInteger n) {
		String nBits = n.toString(2);
		String result = nBits.substring(0, 1);
		for ( int i = 1; i < nBits.length(); i++ ) {
			// bin[i] = gray[i] ^ bin[i-1]
			// XOR using characters
			result += nBits.charAt(i) != result.charAt(i - 1) ? "1" : "0";
		}
		return new BigInteger(result, 2);
	}
	
	/**
	 * An alternative version of grayEncode,
	 * less efficient, but demonstrates the principal of gray encoding.
	 */
	public static long grayEncode2(long n) {
		long result = 0;
		for ( int exp = 0; n > 0; n >>= 1, exp++ ) {
			long nextHighestBit = ( n >> 1 ) & 1;
			if ( nextHighestBit == 1 ) {
				result += ( ( n & 1 ) == 0 ) ? ( 1 << exp ) : 0; // flip this bit
			} else {
				result += ( n & 1 ) * ( 1 << exp ); // don't flip this bit
			}
		}
		return result;
	}
	
	public static void main(String[] args){
		System.out.println("i\tBinary\tGray\tGray2\tDecoded");
		System.out.println("=======================================");
		for ( int i = 0; i < 32; i++ ) {
			System.out.print(i + "\t");
			System.out.print(Integer.toBinaryString(i) + "\t");
			System.out.print(Long.toBinaryString(grayEncode(i)) + "\t");
			System.out.print(Long.toBinaryString(grayEncode2(i)) + "\t");
			System.out.println(grayDecode(grayEncode(i)));
		}
		System.out.println();
		
		final BigInteger base = BigInteger.TEN.pow(25).add( new BigInteger("12345678901234567890") );		
		for ( int i = 0; i < 5; i++ ) {
			BigInteger test = base.add(BigInteger.valueOf(i));
			System.out.println("test decimal      = " + test);
			System.out.println("gray code decimal = " + grayEncode(test));
			System.out.println("gray code binary  = " + grayEncode(test).toString(2));
			System.out.println("decoded decimal   = " + grayDecode(grayEncode(test)));
			System.out.println("decoded2 decimal  = " + grayDecode2(grayEncode(test)));
			System.out.println();
		}
	}
	
}
