import java.util.ArrayList;
import java.util.List;
import java.util.function.BiFunction;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class AmbTask {

	public static void main(String[] aArgs) {
		List<List<String>> words = List.of(
			List.of( "the", "that", "a" ),
		    List.of( "frog", "elephant", "thing" ),
		    List.of( "walked", "treaded", "grows" ),
		    List.of( "slowly", "quickly" ) );		

		System.out.println(Amb(words));		
	}
	
	private static String Amb(List<List<String>> aOptions) {
		BiFunction<String, String, Boolean> continues = (before, after) -> before.endsWith(after.substring(0, 1));		
		List<String> ambResult = amb(continues, aOptions, "");
		return ( ambResult.isEmpty() ) ? "No match found" : String.join(" ", ambResult);		
	}
	
	private static List<String> amb(
			BiFunction<String, String, Boolean> aBiFunction, List<List<String>> aOptions, String aPrevious) {
		
		if ( aOptions.isEmpty() ) {
			return new ArrayList<String>();
		}

		for ( String option : aOptions.get(0) ) {
		    if ( ! aPrevious.isEmpty() && ! aBiFunction.apply(aPrevious, option) ) {
		    	continue;
			}
	
		    if ( aOptions.size() == 1 ) {
		    	return Stream.of(option).collect(Collectors.toList());
		    }
	
		    List<String> result = (ArrayList<String>) amb(aBiFunction, aOptions.subList(1, aOptions.size()), option);
	
		    if ( ! result.isEmpty() ) {
				result.add(0, option);
				return result;
			}	
		}
		
		return new ArrayList<String>();
	}
	
}
