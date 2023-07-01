import java.util.Optional;

public final class TropicalAlgebra {

	public static void main(String[] aArgs) {
		final Tropical a = new Tropical(-2);
		final Tropical b = new Tropical(-1);
		final Tropical c = new Tropical(-0.5);
		final Tropical d = new Tropical(-0.001);
		final Tropical e = new Tropical(0);
		final Tropical f = new Tropical(1.5);
		final Tropical g = new Tropical(2);
		final Tropical h = new Tropical(5);
		final Tropical i = new Tropical(7);
		final Tropical j = new Tropical(8);
		final Tropical k = new Tropical();
		
		System.out.println("2 x -2 = " + g.multiply(a));
		System.out.println("-0.001 + -Inf = " + d.add(k));
		System.out.println("0 x -Inf = " + e.multiply(k));
		System.out.println("1.5 + -1 = " + f.add(b));
		System.out.println("-0.5 x 0 = " + c.multiply(e));
		
		System.out.println();
		System.out.println("5^7 = " + h.power(7));		
		
		System.out.println();
		System.out.println("5 * ( 8 + 7 ) = " + h.multiply(j.add(i)));
		System.out.println("5 * 8 + 5 * 7 = " + h.multiply(j).add(h.multiply(i)));		
	}

}

final class Tropical {
	
	public Tropical(Number aNumber) {
		if ( aNumber == null ) {
			throw new IllegalArgumentException("Number cannot be null");
		}
		
		optional = Optional.of(aNumber);
	}
	
	public Tropical() {
		optional = Optional.empty();
	}
	
	@Override
	public String toString() {
		if ( optional.isEmpty() ) {
			return "-Inf";
		}
	
		String value = String.valueOf(optional.get());
		final int index = value.indexOf(".");
		if ( index >= 0 ) {
			value = value.substring(0, index);
		}
		
		return value;
	}
	
	public Tropical add(Tropical aOther) {
		if ( aOther.optional.isEmpty() ) {
			return this;
		}
		
		if ( optional.isEmpty() ) {
			return aOther;
		}
		
		if ( optional.get().doubleValue() > aOther.optional.get().doubleValue() ) {
			return this;
		}		
		return aOther;
	}
	
	public Tropical multiply(Tropical aOther) {
		if ( optional.isPresent() && aOther.optional.isPresent() ) {
			double result = optional.get().doubleValue() + aOther.optional.get().doubleValue();			
			return new Tropical(result);
		}
		
		return new Tropical();
	}
	
	public Tropical power(int aExponent) {
		if ( aExponent <= 0 ) {
			throw new IllegalArgumentException("Power must be positive");
		}
		
		Tropical result = this;;
	    for ( int i = 1; i < aExponent; i++ ) {
	        result = result.multiply(this);
	    }
	
	    return result;
	}
	
	private Optional<Number> optional;
	
}
