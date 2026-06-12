import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.IntStream;

public final class PriceListBehindAPI {

	public static void main(String[] args) {
		ThreadLocalRandom random = ThreadLocalRandom.current();
		final int numberPrices = random.nextInt(99_000, 101_000);
		priceList = IntStream.range(0, numberPrices).map( i -> random.nextInt(0, 100_000) ).boxed().toList();
		final int maxPrice = getMaxPrice();
		
		System.out.println("Using " + numberPrices + " random prices from 0 to " + maxPrice);
		List<PriceDetail> priceDetails = getAll5000(0, maxPrice, 5_000);
		System.out.println("Split into " + priceDetails.size() + " partitions of 5,000 or fewer elements:");
		for ( PriceDetail priceDetail : priceDetails ) {
		    final int minPartitionPrice = priceDetail.minPrice;
		    final int maxPartitionPrice = priceDetail.maxPrice;
		    final int numberPartitionPrices = priceDetail.numberPrices;
		    System.out.println("    From %6d to %6d with %4d items"
		    	.formatted(minPartitionPrice, maxPartitionPrice, numberPartitionPrices));
		}
	}
	
	private static int getPriceRangeCount(int startPrice, int endPrice) {
		return (int) priceList.stream().filter( i -> startPrice <= i && i <= endPrice ).count();
	}
	
	private static int getMaxPrice() {
		return priceList.stream().mapToInt( i -> i ).max().getAsInt();
	}
	
	private static List<PriceDetail> getAll5000(int minPrice, int maxPrice, int numberPrices) {
	    PriceDetail priceDetail = get5000(minPrice, maxPrice, numberPrices);
	    int greatestPrice = priceDetail.maxPrice;
	    int countPrices = priceDetail.numberPrices;
	    List<PriceDetail> priceDetails = new ArrayList<PriceDetail>();
	    priceDetails.addLast( new PriceDetail(minPrice, greatestPrice, countPrices) );
	    while ( greatestPrice < maxPrice ) {
	        final int leastPrice = greatestPrice + 1;
	        priceDetail = get5000(leastPrice, maxPrice, numberPrices);
	        greatestPrice = priceDetail.maxPrice;
	        countPrices = priceDetail.numberPrices;
	        if ( countPrices == 0 ) {
	        	throw new AssertionError("Price list from " + leastPrice + " has too many with same price.");
	        }
	        priceDetails.addLast( new PriceDetail(leastPrice, greatestPrice, countPrices) );
	    }
	    return priceDetails;
	}
	
	private static PriceDetail get5000(int minPrice, int maxPrice, int numberPrices) {
	    int countPrices = getPriceRangeCount(minPrice, maxPrice);
	    double delta = ( maxPrice - minPrice ) / 2.0;
	    while ( countPrices != numberPrices && delta >= 0.5 ) {
	        maxPrice = (int) Math.floor( ( countPrices > numberPrices ) ? maxPrice - delta : maxPrice + delta );
	        countPrices = getPriceRangeCount(minPrice, maxPrice);
	        delta /= 2.0;
	    }
	    return new PriceDetail(0, maxPrice, countPrices);
	}
	
	private record PriceDetail(int minPrice, int maxPrice, int numberPrices) {}
	
	private static List<Integer> priceList;

}
