public final class ModularInverse {

	public static void main(String[] aArgs) {
		System.out.println(inverseModulus(42, 2017));
	}
	
	private static Egcd extendedGCD(int aOne, int aTwo) {
		if ( aOne == 0 ) {
	        return new Egcd(aTwo, 0, 1);
		}
	    Egcd value = extendedGCD(aTwo % aOne, aOne);	
	    return new Egcd(value.aG, value.aY - ( aTwo / aOne ) * value.aX, value.aX);	
	}
	    		
	private static int inverseModulus(int aNumber, int aModulus) {
	    Egcd value = extendedGCD(aNumber, aModulus);
	    return ( value.aG == 1 ) ? ( value.aX + aModulus ) % aModulus : 0;
	}
	
	private static record Egcd(int aG, int aX, int aY) {}

}
