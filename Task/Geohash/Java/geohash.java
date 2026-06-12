import java.util.ArrayList;
import java.util.List;

public final class Geohash {

	public static void main(String[] args) {
		List<Location> locations = List.of(
			new Location(51.433718, -0.214126), new Location(51.433718, -0.214126),
			new Location(57.64911, 10.40744), new Location(57.64911, 10.40744) );
		List<Integer> precisions = List.of( 2, 9, 11, 21 );
		
		List<String> testResults = new ArrayList<String>();
		for ( int i = 0; i < locations.size(); i++ ) {
			testResults.addLast(encodeGeohash(locations.get(i), precisions.get(i)));
			System.out.println("geohash for " + locations.get(i) + " with precision "
				+ precisions.get(i) + " => " + testResults.getLast());
		}
		System.out.println();
		
		for ( String testResult : testResults ) {
			System.out.println(String.format("%-21s%s%s", testResult, " => ", decodeGeohash(testResult)));
		}
	}
	
	private static String encodeGeohash(Location location, int precision) {
	    Range latitudeRange = new Range(-90.0, 90.0);
	    Range longitudeRange = new Range(-180.0, 180.0);
	    StringBuilder geohash = new StringBuilder();
	    int geohashValue = 0;
	    int bitCount = 0;
	    boolean even = true;
	
	    while ( geohash.length() < precision ) {
	    	final double value = even ? location.longitude : location.latitude;
	    	Range range = even ? longitudeRange : latitudeRange;
	        final double midRange = ( range.lower + range.upper ) / 2;
	
	        if ( value > midRange ) {
	            geohashValue = ( geohashValue << 1 ) + 1;
	            range = new Range(midRange, range.upper);
	            if ( even ) {
	                longitudeRange = new Range(midRange, longitudeRange.upper);
	            } else {
	                latitudeRange = new Range(midRange, latitudeRange.upper);
	            }
	        } else {
	            geohashValue <<= 1;
	            if ( even ) {
	                longitudeRange = new Range(longitudeRange.lower, midRange);
	            } else {
	                latitudeRange = new Range(latitudeRange.lower, midRange);
	            }
	        }
	
	        even = ! even;
            if ( bitCount < 4 ) {
                bitCount += 1;
            } else {
                bitCount = 0;
                geohash.append(GEO_BASE_32.charAt(geohashValue));
                geohashValue = 0;
            }	    	
	    }	
	    return geohash.toString();
	}
	
	private static String decodeGeohash(String hash) {
		Range latitudeRange = new Range(-90.0, 90.0);
		Range longitudeRange = new Range(-180.0, 180.0);
		boolean even = true;
	
	    for ( int i = 0; i < hash.length(); i++ ) {
	    	final int position = GEO_BASE_32.indexOf(hash.substring(i, i + 1));
	    	String temp = Integer.toBinaryString(position);
	    	String binary = String.format("%5s", temp).replace(" ", "0");
	    	
	        for ( int j = 0; j < 5; j++ ) {
	        	final double midRange = even ?
	        		  ( longitudeRange.lower + longitudeRange.upper ) / 2
	        		: ( latitudeRange.lower + latitudeRange.upper ) / 2;
	        	if ( binary.charAt(j) == '0' ) {
	        		if ( even ) {
	        			longitudeRange = new Range(longitudeRange.lower, midRange);
	        		} else {
	        			latitudeRange = new Range(latitudeRange.lower, midRange);	        			
	        		}
	        	} else {
	        		if ( even ) {
	        			longitudeRange = new Range(midRange, longitudeRange.upper);
	        		} else {
	        			latitudeRange = new Range(midRange, latitudeRange.upper);	        			
	        		}
	        	}
	            even = ! even;
	        }
		}
	
	    final double latitudeError = Math.abs(latitudeRange.lower - latitudeRange.upper);
	    final double longitudeError = Math.abs(longitudeRange.lower - longitudeRange.upper);
	    final double midLatitude = ( latitudeRange.lower + latitudeRange.upper ) / 2;
	    final double midLongitude = ( longitudeRange.lower + longitudeRange.upper ) / 2;
	    return new Location(midLatitude, midLongitude) + " ± " + Math.max(latitudeError, longitudeError);
	}
	
	private static record Location(double latitude, double longitude) {
		
		public String toString() {
			String sectorSN = ( latitude < 0 ) ? " S" : " N";
			String sectorWE = ( longitude < 0 ) ? " W" : " E";
			return "(" + Math.abs(latitude) + sectorSN + ", " + Math.abs(longitude) + sectorWE + ")";
		}		
		
	}
	
	private static record Range(double lower, double upper) {}
	
	private static final String GEO_BASE_32 = "0123456789bcdefghjkmnpqrstuvwxyz";

}
