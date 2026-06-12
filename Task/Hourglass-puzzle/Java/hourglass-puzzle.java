public final class HourglassPuzzle {

	public static void main(String[] args) {
		final int timeLimit = 10_000;
		final int timeRequired = 9;
		
		int fourHourglass = 0;
		int sevenHourglass = 0;
	
	    while ( fourHourglass < timeLimit ) {
	        sevenHourglass = 7 - ( fourHourglass % 7 );
	        if ( sevenHourglass == timeRequired - 4 ) {
	            break;
	        }
	        fourHourglass += 4;
	    }
	
	    if ( fourHourglass >= timeLimit ) {
	    	System.out.println("No solution found");
	    } else {
	    	String textBlock = """
	    		Turn over both hour glasses at the same time and continue flipping them each
	    		when they individually run down until the 4 hour glass has been flipped %d times,
	    		when the 7 hour glass is immediately placed on its side with %d hours of sand in it.
	
	    		You can measure %d hours by flipping the 4 hour glass once,
	    		then flipping the remaining sand in the 7 hour glass when the 4 hour glass ends.	
	    		""";
	    	String formattedTextBlock = textBlock.formatted(fourHourglass / 4, sevenHourglass, timeRequired);
	    	System.out.println(formattedTextBlock);	    	
	    }
	}

}
