import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class HorseRacing {

	public static void main(String[] args) {
		// Horses with their rating after the first 3 races
		Map<String, Info> horses = new HashMap<String, Info>(Map.ofEntries(
			Map.entry("A", new Info(Gender.COLT, 100.0) ),
			Map.entry("B", new Info(Gender.FILLY, 100.0 - 8 - 2 * 2)),
			Map.entry("C", new Info(Gender.COLT, 100.0 + 4 - 2 * 3.5)),
			Map.entry("D", new Info(Gender.FILLY, 100.0 - 4 - 10 * 0.4)),
			Map.entry("E", new Info(Gender.COLT, ( 100.0 - 4 - 10 * 0.4 ) + 7 - 2 * 1)),
			Map.entry("F", new Info(Gender.COLT, ( 100.0 - 4 - 10 * 0.4 ) + 11 - 2 * ( 4 - 2 ))),
			Map.entry("G", new Info(Gender.COLT, 100.0 - 10 + 10 * 0.2)),
			Map.entry("H", new Info(Gender.COLT, ( 100.0 - 10 + 10 * 0.2 ) + 6 - 2 * 1.5)),
			Map.entry("I", new Info(Gender.FILLY, ( 100.0 - 10 + 10 * 0.2 ) + 15 - 2 * 2)),
			Map.entry("J", new Info(Gender.FILLY, null))
		));		

		// Adjustments to ratings for Race 4
		horses.computeIfPresent("B", (k, v) -> new Info(v.gender, v.rating + 4));
		horses.computeIfPresent("C", (k, v) -> new Info(v.gender, v.rating - 4));
		horses.computeIfPresent("H", (k, v) -> new Info(v.gender, v.rating + 3));
		horses.computeIfPresent("J", (k, v) -> new Info(v.gender, 100 - 3 + 10 * 0.2));

		// Filly's weight allowance adjustment
		for ( Map.Entry<String, Info> entry : horses.entrySet() ) {
			if ( entry.getValue().gender == Gender.FILLY ) {
				entry.setValue( new Info(entry.getValue().gender, entry.getValue().rating + 3) );
			}	
		}

		// Sort in descending order of rating
		List<Map.Entry<String, Info>> sortedHorses = horses.entrySet().stream()
            .sorted(Map.Entry.<String, Info>comparingByValue(infoComparator)).toList();
		
		// Display the expected result of Race 4
		System.out.println("Race 4" + System.lineSeparator());
		System.out.println("Position  Horse  Weight  Distance  Gender");
		for ( int i = 0; i < sortedHorses.size(); i++ ) {
			Map.Entry<String, Info> entry = sortedHorses.get(i);
			final double weight = ( entry.getValue().gender == Gender.COLT ) ? 9.00 : 8.11;
			final double distance = ( i > 0 ) ?
				( sortedHorses.get(i - 1).getValue().rating - entry.getValue().rating ) * 0.5 : 0.0;
			final String position = ( i == 0 || distance > 0 ) ? String.valueOf(i + 1) : String.valueOf(i) + "=";
			System.out.println(String.format("   %-4s%6s%9.2f%8.1f%10s",
				position, entry.getKey(), weight, distance, entry.getValue().gender));
		}
		
		// Weight adjusted rating of the winning horse
		final double rating = sortedHorses.getFirst().getValue().rating;

		// Expected time of the winning horse, calculated by comparison to horse A's time in Race 1
		final double time = 96 - ( rating - 100 ) / 10;
		System.out.println(String.format("%n%s%.0f%s%.1f%s",
			"Time ", Math.floor(time / 60), " minute ", time % 60, " seconds"));
	}
	
	private static Comparator<Info> infoComparator = (i1, i2) -> Double.compare(i2.rating, i1.rating);
	
	private enum Gender { COLT, FILLY }
	
	private static record Info(Gender gender, Double rating) {}

}
