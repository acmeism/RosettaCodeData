import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

public final class BoustrophedonTransform {

	public static void main(String[] args) {
		listPrimeNumbersUpTo(8_000);		
		
		Function<Integer, BigInteger> oneOne = x -> ( x == 0 ) ? BigInteger.ONE : BigInteger.ZERO;
		Function<Integer, BigInteger> alternating =
            x -> ( x % 2 == 0 ) ? BigInteger.ONE : BigInteger.ONE.negate();
		
		display("One followed by an infinite series of zeros -> A000111", oneOne);
		display("An infinite series of ones -> A000667", n -> BigInteger.ONE);
		display("(-1)^n: alternating 1, -1, 1, -1 -> A062162", alternating);
		display("Sequence of prime numbers -> A000747", n -> primes.get(n));
		display("Sequence of Fibonacci numbers -> A000744", n -> fibonacci(n));
		display("Sequence of factorial numbers -> A230960", n -> factorial(n));
	}	
	
	private static void listPrimeNumbersUpTo(int limit) {
		primes = new ArrayList<BigInteger>();
		primes.add(BigInteger.TWO);
		final int halfLimit = ( limit + 1 ) / 2;
		boolean[] composite = new boolean[halfLimit];
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				primes.add(BigInteger.valueOf(p));
				for ( int a = i + p; a < halfLimit; a += p ) {
					composite[a] = true;
				}
			}
		}
	}	

	private static BigInteger fibonacci(int number) {
		if ( ! fibonacciCache.keySet().contains(number) ) {
			if ( number == 0 || number == 1 ) {
				fibonacciCache.put(number, BigInteger.ONE);
			} else {
				fibonacciCache.put(number, fibonacci(number - 2).add(fibonacci(number - 1)));
			}
		}		
		return fibonacciCache.get(number);
	}
	
	private static BigInteger factorial(int number) {
		if ( ! factorialCache.keySet().contains(number) ) {
			BigInteger value = BigInteger.ONE;
			for ( int i = 2; i <= number; i++ ) {
				value = value.multiply(BigInteger.valueOf(i));
			}
			factorialCache.put(number, value);
		}		
		return factorialCache.get(number);
	}
	
	private static String compress(BigInteger number, int size) {
		String digits = number.toString();
		final int length = digits.length();
		if ( length <= 2 * size )  {
			return digits;
		}		
		return digits.substring(0, size) + " ... "
            + digits.substring(length - size) + " (" + length + " digits)";
	}
	
	private static void display(String title, Function<Integer, BigInteger> sequence) {
		System.out.println(title);
		BoustrophedonIterator iterator = new BoustrophedonIterator(sequence);
		for ( int i = 1; i <= 15; i++ ) {
			System.out.print(iterator.next() + " ");
		}
		System.out.println();
		for ( int i = 16; i < 1_000; i++ ) {
			iterator.next();
		}		
		System.out.println("1,000th element: " + compress(iterator.next(), 20) + System.lineSeparator());
	}
	
	private static List<BigInteger> primes;
	private static Map<Integer, BigInteger> fibonacciCache = new HashMap<Integer, BigInteger>();
	private static Map<Integer, BigInteger> factorialCache = new HashMap<Integer, BigInteger>();
	
}

final class BoustrophedonIterator {
	
	public BoustrophedonIterator(Function<Integer, BigInteger> aSequence) {
		sequence = aSequence;
	}
	
	public BigInteger next() {
		index += 1;
		return transform(index, index);
	}
	
	private BigInteger transform(int k, int n) {		
		if ( n == 0 ) {
			return sequence.apply(k);
		}
		
		Pair pair = new Pair(k, n);
		if ( ! cache.keySet().contains(pair) ) {
			 final BigInteger value = transform(k, n - 1).add(transform(k - 1, k - n));
			 cache.put(pair, value);
		}
		return cache.get(pair);
	}
	
	private record Pair(int k, int n) {}
	
	private int index = -1;
	private Function<Integer, BigInteger> sequence;
	private Map<Pair, BigInteger> cache = new HashMap<Pair, BigInteger>();	
	
}
