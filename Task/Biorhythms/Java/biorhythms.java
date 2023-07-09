import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;

public final class Biorythms {

	public static void main(String[] aArgs) {
	    List<List<String>> datePairs = List.of(
	    	List.of( "1943-03-09", "1972-07-11" ),
	    	List.of( "1809-01-12", "1863-11-19" ),
	    	List.of( "1809-02-12", "1863-11-19" ));
	
	    for ( List<String> datePair : datePairs ) {
	    	biorhythms(datePair);
	    }
	}
	
	private static void biorhythms(List<String> aDatePair) {
		DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE;
	    LocalDate birthDate = LocalDate.parse(aDatePair.get(0), formatter);
	    LocalDate targetDate = LocalDate.parse(aDatePair.get(1), formatter);
	    final int daysBetween = (int) ChronoUnit.DAYS.between(birthDate, targetDate);
	    System.out.println("Birth date " + birthDate + ", Target date " + targetDate);
	    System.out.println("Days between: " + daysBetween);
	
	    for ( Cycle cycle : Cycle.values() ) {
	        final int cycleLength = cycle.length();
	        final int positionInCycle = daysBetween % cycleLength;
	        final int quadrantIndex = 4 * positionInCycle / cycleLength;	
	        final int percentage = (int) Math.round(100 * Math.sin(2 * Math.PI * positionInCycle / cycleLength));
	
	        String description;
	        if ( percentage > 95 ) {
	        	description = "peak";
	        } else if ( percentage < -95 ) {
	        	description = "valley";
	        } else if ( Math.abs(percentage) < 5 ) {
	            description = "critical transition";
	        } else {
	        	final int daysToTransition = ( cycleLength * ( quadrantIndex + 1 ) / 4 ) - positionInCycle;
		        LocalDate transitionDate = targetDate.plusDays(daysToTransition);
		        List<String> descriptions = cycle.descriptions(quadrantIndex);
		        String trend = descriptions.get(0);
		        String nextTransition = descriptions.get(1);
	            description = percentage + "% (" + trend + ", next " + nextTransition + " " + transitionDate + ")";
	        }
	
	        System.out.println(cycle + " day " + positionInCycle  + ": " + description);
	    }
	    System.out.println();
	}
	
	private enum Cycle {		
		PHYSICAL(23), EMOTIONAL(28), MENTAL(33);
		
		public int length() {
			return length;
		}
		
		public List<String> descriptions(int aNumber) {
			return DESCRIPTIONS.get(aNumber);
		}
				
		private Cycle(int aLength) {
			length = aLength;
		}	
		
		private final int length;
		
		private static final List<List<String>> DESCRIPTIONS = List.of(
			List.of( "up and rising", "peak" ), List.of( "up but falling", "transition" ),
		    List.of( "down and falling", "valley" ), List.of( "down but rising", "transition" )); 		
	}

}
