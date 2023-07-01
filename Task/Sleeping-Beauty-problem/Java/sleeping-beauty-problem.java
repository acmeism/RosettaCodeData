import java.util.concurrent.ThreadLocalRandom;

public final class SleepingBeauty {

	public static void main(String[] aArgs) {
		final int experiments = 1_000_000;
	    ThreadLocalRandom random = ThreadLocalRandom.current();
	
	    enum Coin { HEADS, TAILS }
	
	    int heads = 0;
	    int awakenings = 0;	
	
	    for ( int i = 0; i < experiments; i++ ) {
	        Coin coin = Coin.values()[random.nextInt(0, 2)];
	        switch ( coin ) {
	        	case HEADS -> { awakenings += 1; heads += 1; }
	        	case TAILS -> awakenings += 2;
	        }
	    }
	
	    System.out.println("Awakenings over " + experiments + " experiments: " + awakenings);
	    String credence = String.format("%.3f", (double) heads / awakenings);
	    System.out.println("Sleeping Beauty should estimate a credence of: " + credence);
	}
	
}
