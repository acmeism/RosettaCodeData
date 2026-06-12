public final class ShowTheDecimalValueOfANumberOf1sAppendedWithA3ThenSquared {

	public final static void main(String[] args) {
		for ( int i = 0; i < 8; i++ ) {
			final long value = Long.valueOf("1".repeat(i) + "3");
			System.out.println(String.format("%9s%s", value, " => " + value * value));
		}
	}
	
}
