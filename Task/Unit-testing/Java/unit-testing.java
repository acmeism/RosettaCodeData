package distanceAndBearing;

import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

@DisplayName("Distance and Bearing")
public class DistanceAndBearingTest {

	private Airport ap;
    @Test
	@DisplayName("Should list top 20 airports when searched")
	void shouldListTop20AirportsWhenSearched() {
		ArrayList<String> correctResults = new ArrayList<>();
		correctResults.add("Koksijde Air Base");
		correctResults.add("Ostend-Bruges International Airport");
		correctResults.add("Kent International Airport");
		correctResults.add("Calais-Dunkerque Airport");
		correctResults.add("Westkapelle heliport");
		correctResults.add("Lympne Airport");
		correctResults.add("Ursel Air Base");
		correctResults.add("Southend Airport");
		correctResults.add("Merville-Calonne Airport");
		correctResults.add("Wevelgem Airport");
		correctResults.add("Midden-Zeeland Airport");
		correctResults.add("Lydd Airport");
		correctResults.add("RAF Wattisham");
		correctResults.add("Beccles Airport");
		correctResults.add("Lille/Marcq-en-Baroeul Airport");
		correctResults.add("Lashenden (Headcorn) Airfield");
		correctResults.add("Le Touquet-Côte d'Opale Airport");
		correctResults.add("Rochester Airport");
		correctResults.add("Lille-Lesquin Airport");
		correctResults.add("Thurrock Airfield");
	
		List<Airport> results;
		DistanceAndBearing dandb = new DistanceAndBearing();
		boolean success = dandb.readFile("airports.txt");
		results = dandb.findClosestAirports(this.ap.getLat(), this.ap.getLon());
		List<String> airports = results.stream().map(ap -> ap.getAirportName()).collect(Collectors.toList());
		
		airports.stream().forEach(airport ->{
			assertTrue(correctResults.contains(airport));
		});
		
	}
