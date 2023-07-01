public final class MiddleSquareTask {

	public static void main(String[] aArgs) {
		MiddleSquare random = new MiddleSquare(675248);
		
		for ( int i = 0; i < 5; i++ ) {
	        System.out.println(random.nextInt());
		}
	}	

}

final class MiddleSquare {
	
	public MiddleSquare(int aSeed) {
		final int length = String.valueOf(aSeed).length();
		if ( length % 2 == 1 ) {
			throw new IllegalArgumentException("Seed must have an even number of digits");
		}
		
		state = aSeed;
		divisor = (int) Math.pow(10, length / 2);
		modulus = (int) Math.pow(10, length);
	}
	
	public int nextInt() {
		state = ( ( state * state ) / divisor ) % modulus;		
		return (int) state;
	}
	
	private long state;
	
	private final int divisor, modulus;
	
}
