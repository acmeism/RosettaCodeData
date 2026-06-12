import java.util.List;

public final class FindMinimumNumberOfCoinsThatMakeAGivenValue {

	public static void main(String[] args) {
		List<Integer> coins = List.of( 200, 100, 50, 20, 10, 5, 2, 1 );	
		int coinCount = 0;
		int remaining = 988;				
		System.out.println("The minimum number of coins needed to make a value of " + remaining + " is:");		
		for ( int i = 0; i < coins.size() && remaining > 0; i++ ) {
		    final int n = remaining / coins.get(i);
		    coinCount += n;
		    System.out.println(String.format("    %3d%s%d", coins.get(i), " x ", n));
		    remaining %= coins.get(i);
		}
		System.out.println();
		System.out.println("A total of " + coinCount + " coins.");
	}

}
