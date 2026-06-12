import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.IntStream;

public final class LunarAithnetic {

	public static void main(String[] args) {
		List.of( List.of( 976, 348 ) , List.of( 23, 321 ), List.of( 232, 35 ), List.of( 123, 32192, 415, 8 ) )		
		.forEach( test -> {
			String addExpression = String.join(" 🌙 + ", test.stream().map(String::valueOf).toList());
			Lunar addResult = test.stream().map( i -> new Lunar(i) ).reduce(Lunar.ZERO, (a, b) -> a.add(b));
			System.out.println(addExpression + " = " + addResult);
			
			String multiplyExpression = String.join(" 🌙 x ", test.stream().map(String::valueOf).toList());
			Lunar multiplyResult = test.stream().map( i -> new Lunar(i) ).reduce(Lunar.NINE, (a, b) -> a.multiply(b));
			System.out.println(multiplyExpression + " = " + multiplyResult);
			System.out.println();
		} );
		
		System.out.println("First 20 distinct lunar even numbers:");
		Set<Lunar> evens = new TreeSet<Lunar>();
		Lunar n = Lunar.ZERO;		
	    while ( evens.size() < 20 ) {
	        evens.add(n.multiply( new Lunar(2) ));
	        n = n.increment();
	    }
	    System.out.println(String.join(" ", evens.stream().map(String::valueOf).toList()));
	    System.out.println();
		
		System.out.println("First 20 lunar square numbers:");
		IntStream.range(0, 20).forEach( i -> System.out.print( new Lunar(i).multiply( new Lunar(i) ) + " ") );
		System.out.println(System.lineSeparator());
		
		System.out.println("First 20 lunar factorials:");
		Lunar factorial = new Lunar(1);
		for ( int i = 1; i <= 20; i++ ) {
			factorial = factorial.multiply( new Lunar(i) );
			System.out.print(factorial + " ");
		}
		System.out.println(System.lineSeparator());	
		
		Lunar current = Lunar.ZERO;
		Lunar next = Lunar.ZERO;
		while ( current.multiply(current).compareTo(next.multiply(next)) <= 0 ) {
			current = next;
			next = next.increment();			
		}
		System.out.println("First number whose lunar square is smaller than the previous: " + next);
	}

}

final class Lunar implements Comparable<Lunar> {
	
	public Lunar(long aN) {
		if ( aN < 0 ) {
			throw new IllegalArgumentException("Argument must be a non-negative integer.");
		}		
		text = String.valueOf(aN);
	}
	
	public Lunar add(Lunar other) {
	    final int maxLength = Math.max(text.length(), other.text.length());
	    String a = "0".repeat(maxLength - text.length()) + text;
	    String b = "0".repeat(maxLength - other.text.length()) + other.text;	
	    StringBuilder sum = new StringBuilder();
	    IntStream.range(0, a.length()).forEach( i -> {
	    	sum.append(Character.toString((char) Math.max(a.charAt(i), b.charAt(i))));
	    } );	
	    return new Lunar(Long.parseLong(sum.toString()));
	}
	
    public Lunar multiply(Lunar other) {
	    Lunar result = Lunar.ZERO;
	    String reversed = new StringBuilder(other.text).reverse().toString();
	    for ( int i = 0; i < reversed.length(); i++ ) {
	    	final char digit = reversed.charAt(i);	    	
	    	StringBuilder row = new StringBuilder();
	    	IntStream.range(0, text.length()).forEach( j -> {
	    		row.append(Character.toString((char) Math.min(text.charAt(j), digit)));
	    	} );
	    	row.append("0".repeat(i));
	        result = result.add( new Lunar(Long.parseLong(row.toString())) );
	    }
	    return result;
	}

    public Lunar increment() {
    	return new Lunar(Long.parseLong(text) + 1);
    }

    @Override
   	public int compareTo(Lunar other) {
   		return Long.compare(Long.parseLong(text), Long.parseLong(other.text));
   	}   	

    @Override
    public boolean equals(Object other) {
    	return switch ( other ) {
    		case Lunar lunar -> text.equals(lunar.text);
    		case Object object -> false;
    	};
    }

    @Override
	public String toString() {
		return text;
	}
	
	public static final Lunar ZERO = new Lunar(0); // Additive identity
	public static final Lunar NINE = new Lunar(9); // Multiplicative identity

	private String text;
	
}
