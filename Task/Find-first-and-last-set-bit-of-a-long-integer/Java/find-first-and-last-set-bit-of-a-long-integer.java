public class FirstAndLastBits {

    public static long LSB(Long aNumber) {
		if ( aNumber <= 0 ) {
			throw new IllegalArgumentException("Number must be positive");
		}		
		return Long.numberOfTrailingZeros(aNumber);
	}
	
	public static long MSB(Long aNumber) {
		if ( aNumber <= 0 ) {
			throw new IllegalArgumentException("Number must be positive");
		}		
		return 63 - Long.numberOfLeadingZeros(aNumber);
	}
	
	public static long LSB(BigInteger aNumber) {
		if ( aNumber.signum() <= 0 ) {
			throw new IllegalArgumentException("Number must be positive");
		}		
		return aNumber.getLowestSetBit();
	}
	
	public static long MSB(BigInteger aNumber) {
		if ( aNumber.signum() <= 0 ) {
			throw new IllegalArgumentException("Number must be positive");
		}		
		return aNumber.bitLength() - 1;
	}
	
	public static void main(String[] aArgs) {
		Long powerOf42 = 1L;		
		for ( int i = 0; i <= 11; i++ ) {
			System.out.print(String.format("%-5s%-3s%s", "42 ^ ", i, " = "));
			System.out.print(String.format("%1$" + 64 + "s", Long.toBinaryString(powerOf42)).replace(" ", "0"));
			System.out.println(String.format("%s%-2s%s%-2s", " -> LSB: ", LSB(powerOf42), ", MSB: ", MSB(powerOf42)));
			powerOf42 *= 42;
		}
		System.out.println();
		
		BigInteger bigInteger1302 = BigInteger.valueOf(1302);
		BigInteger powerOf1302 = BigInteger.ONE;		
		for ( int i = 0; i <= 6; i++ ) {
			System.out.print(String.format("%-7s%s%s", "1302 ^ ", i, " = "));
			System.out.print(String.format("%1$" + 64 + "s", powerOf1302.toString(2)).replace(" ", "0"));
			String line = String.format("%s%-2s%s%-2s", " -> LSB: ", LSB(powerOf1302), ", MSB: ", MSB(powerOf1302));
			System.out.println(line);
			powerOf1302 = powerOf1302.multiply(bigInteger1302);
		}
	}

}
