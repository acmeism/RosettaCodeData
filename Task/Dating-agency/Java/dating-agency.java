import java.util.List;

public final class DatingAgency {

	public static void main(String[] args) {
		List<String> sailors = List.of(
			"Adrian", "Caspian", "Dune", "Finn", "Fisher", "Heron", "Kai", "Ray", "Sailor", "Tao" );
		
		List<String> ladies = List.of(
			"Ariel", "Bertha", "Blue", "Cali", "Catalina", "Gale", "Hannah", "Isla", "Marina", "Shelly" );
		
		ladies.forEach( lady -> {
		    if ( lovesASailor(lady) ) {
		        System.out.println("Dating service should offer a date with " + lady);
		        for ( String sailor : sailors ) {
		            if ( lovesALady(lady, sailor) ) {
		                System.out.println("    Sailor " + sailor +  " should take an offer to date her");
		            }
		        }
		    } else {
		        System.out.println("Dating service should NOT offer a date with " + lady);
		    }
		} );
	}

	private static boolean lovesASailor(String lady) {
		return lady.charAt(0) % 2 == 0;
	}
	
	private static boolean lovesALady(String lady, String sailor) {
		return lady.charAt(lady.length() - 1) % 2 == sailor.charAt(sailor.length() - 1) % 2;
	}

}
