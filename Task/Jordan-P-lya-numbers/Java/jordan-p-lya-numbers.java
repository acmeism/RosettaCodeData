import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

public final class JordanPolyaNumbers {

	public static void main(String[] aArgs) {		
		createJordanPolya();
		
		final long belowHundredMillion = jordanPolyaSet.floor(100_000_000L);		
		List<Long> jordanPolya = new ArrayList<Long>(jordanPolyaSet);
		
		System.out.println("The first 50 Jordan-Polya numbers:");
		for ( int i = 0; i < 50; i++ ) {
			System.out.print(String.format("%5s%s", jordanPolya.get(i), ( i % 10 == 9 ? "\n" : "" )));
		}
		System.out.println();
		
		System.out.println("The largest Jordan-Polya number less than 100 million: " + belowHundredMillion);
		System.out.println();
		
		for ( int i : List.of( 800, 1050, 1800, 2800, 3800 ) ) {
			System.out.println("The " + i + "th Jordan-Polya number is: " + jordanPolya.get(i - 1)
				+ " = " + toString(decompositions.get(jordanPolya.get(i - 1))));
		}
	}
	
	private static void createJordanPolya() {
		jordanPolyaSet.add(1L);
		Set<Long> nextSet = new TreeSet<Long>();
		decompositions.put(1L, new TreeMap<Integer, Integer>());
		long factorial = 1;
		
		for ( int multiplier = 2; multiplier <= 20; multiplier++ ) {
			factorial *= multiplier;			
			for ( Iterator<Long> iterator = jordanPolyaSet.iterator(); iterator.hasNext(); ) {
				long number = iterator.next();
				while ( number <= Long.MAX_VALUE / factorial ) {
					long original = number;					
					number *= factorial;					
					nextSet.add(number);
		      		decompositions.put(number, new TreeMap<Integer, Integer>(decompositions.get(original)));		      		
		      		decompositions.get(number).merge(multiplier, 1, Integer::sum);
				}
		    }			
			jordanPolyaSet.addAll(nextSet);
			nextSet.clear();
		}
	}
	
	private static String toString(Map<Integer, Integer> aMap) {
		String result = "";
		for ( int key : aMap.keySet() ) {
			result = key + "!" + ( aMap.get(key) == 1 ? "" :"^" + aMap.get(key) ) + " * " + result;
		}		
		return result.substring(0, result.length() - 3);
	}

	private static TreeSet<Long> jordanPolyaSet = new TreeSet<Long>();
	private static Map<Long, Map<Integer, Integer>> decompositions = new HashMap<Long, Map<Integer, Integer>>();	

}
