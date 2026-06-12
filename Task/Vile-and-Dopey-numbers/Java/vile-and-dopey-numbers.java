import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

public final class VileAndDopeyNumbers {

	public static void main(String[] args) {
		Predicate<Integer> isVile = n -> {
			int count = 0;
		    while ( ( n & 1 ) == 0 ) {
		        n >>= 1;
		        count += 1;
		    }
		    return count % 2 == 0;
		};
		
		List<Integer> viles = new ArrayList<Integer>();
		List<Integer> dopeys = new ArrayList<Integer>();
		
		int number = 1;
		while ( viles.size() < 25 || dopeys.size() < 25 ) {
			switch ( isVile.test(number) ) {
				case true -> viles.addLast(number);
				case false -> dopeys.addLast(number);
			};			
			number += 1;
		}
	
		System.out.println("The first 25 Vile numbers:");
		System.out.println(viles.subList(0, 25));		
		System.out.println("\nThe first 25 Dopey numbers:");
		System.out.println(dopeys.subList(0, 25));
		
		System.out.println("\nUpto:  Vile  Dopey");
		int limit = 2;
		int vileCount = 0;
		int dopeyCount = 0;
		int n = 1;
		while ( n <= limit && limit <= 1024 ) {
		    switch ( isVile.test(n) ) {
		    	case true -> vileCount += 1;
		    	case false -> dopeyCount += 1;
		    };		
		    if ( n == limit ) {
		        System.out.println("%4d:   %3d    %3d".formatted(limit, vileCount, dopeyCount));
		        limit *= 2;
		    }
		    n += 1;
		}		
	}	

}
