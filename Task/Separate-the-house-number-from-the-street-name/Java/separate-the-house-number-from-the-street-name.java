import java.util.List;

public final class SeparateTheHouseNumberFromTheStreetName {

	public static void main(String[] args) {
		List<String> addresses = List.of(
	        "Plataanstraat 5",
	        "Straat 12",
	        "Straat 12 II",
	        "Dr. J. Straat   12",
	        "Dr. J. Straat 12 a",
	        "Dr. J. Straat 12-14",
	        "Laan 1940 - 1945 37",
	        "Plein 1940 2",
	        "1213-laan 11",
	        "16 april 1944 Pad 1",
	        "1e Kruisweg 36",
	        "Laan 1940-'45 66",
	        "Laan '40-'45",
	        "Langeloërduinen 3 46",
	        "Marienwaerdt 2e Dreef 2",
	        "Provincialeweg N205 1",
	        "Rivium 2e Straat 59.",
	        "Nieuwe gracht 20rd",
	        "Nieuwe gracht 20rd 2",
	        "Nieuwe gracht 20zw /2",
	        "Nieuwe gracht 20zw/3",
	        "Nieuwe gracht 20 zw/4",
	        "Bahnhofstr. 4",
	        "Wertstr. 10",
	        "Lindenhof 1",
	        "Nordesch 20",
	        "Weilstr. 6",
	        "Harthauer Weg 2",
	        "Mainaustr. 49",
	        "August-Horch-Str. 3",
	        "Marktplatz 31",
	        "Schmidener Weg 3",
	        "Karl-Weysser-Str. 6"
	    );
		
		System.out.println("Street                   House Number");
	    System.out.println("---------------------    ------------");
	    addresses.forEach( address -> {
	    	Tuple result = separateStreetAndHouse(address);
	    	System.out.println(String.format("%-25s%s",
	    		result.street, result.house.equals("") ? "(none)" : result.house ));
		} );	

	}
	
	private static Tuple separateStreetAndHouse(String address) {
		String house = "";
		
	    String[] fields = address.split("\\s+");
	    String last = fields[fields.length - 1];
	    String penultimate = fields[fields.length - 2];
	    if ( Character.isDigit(last.charAt(0) ) ) {
	    	final boolean isDigit = Character.isDigit(penultimate.charAt(0));
	    	if ( fields.length > 2 && isDigit && ! penultimate.startsWith("194") ) {
	    		house = penultimate + " " + last;
	    	} else {
	    		house = last;
	    	}
	    } else if ( fields.length > 2 ) {
	    	house = penultimate + " " + last;
	    }
	
	    String street = address.substring(0, address.length() - house.length()).stripTrailing();
	    return new Tuple(street, house);
	}
	
	private static record Tuple(String street, String house) {}
	
}
