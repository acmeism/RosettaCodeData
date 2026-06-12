import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

public final class TimeConventionsAndConversions {

	public static void main(String[] args) {
		System.out.println("       UTC                      Unix                 NTP"
	                       + "                  TAI                  GPS");
		System.out.println("-".repeat(107));	
		List<String> utcs = List.of(
			"0001-01-01T00:00:00", "1900-01-01T00:00:00", "1958-01-01T00:00:00",
			"1970-01-01T00:00:00", "1980-01-06T00:00:00", "1989-12-31T00:00:00",
			"1990-01-01T00:00:00", "2025-06-01T00:00:00", "2050-01-01T00:00:00" );
		utcs.forEach( s -> System.out.println(String.format("%-23s %16.0f %20.0f %20.0f %20.0f",
			s, utc2unix.apply(s), utc2ntp.apply(s), utc2tai.apply(s), utc2gps.apply(s) )));
		
		List<Double> unixs = List.of( 1810753809.806, 154956295.688, 780673454.121 );
		unixs.forEach( i -> { String dateTime = unix2utc.apply(i).replace(" ", "T");
		    System.out.println(String.format("%-23s %20.3f %20.3f %20.3f %20.3f",
		    	dateTime, i, unix2ntp.apply(i), unix2tai.apply(i), unix2gps.apply(i)));			
		});
		
		List<Double> ntps = List.of( 2871676795.0, 2335219189.0, 3029443171.0 );
		ntps.forEach( i -> { String dateTime = ntp2utc.apply(i).replace(" ", "T");
		    System.out.println(String.format("%-23s %16.0f %20.0f %20.0f %20.0f",
		    	dateTime, ntp2unix.apply(i), i, ntp2tai(i), ntp2gps.apply(i)));			
		});
		
		List<Double> tais = List.of( 996796823.0, 996796824.0, 996796825.0, 996796826.0 );
		tais.forEach( i -> { String dateTime = tai2utc.apply(i).replace(" ", "T");
		    System.out.println(String.format("%-23s %16.0f %20.0f %20.0f %20.0f",
		    	dateTime, tai2unix.apply(i), tai2ntp(i), i, tai2gps.apply(i)));			
		});
		
		List<Double> gpss = List.of( 996796804.250, 996796805.5, 996796806.750, 996796807.9999 );
		gpss.forEach( i -> { String dateTime = gps2utc.apply(i).replace(" ", "T");
		    System.out.println(String.format("%-24s %20.4f %20.4f %20.4f %20.4f",
		    	dateTime, gps2unix.apply(i), gps2ntp.apply(i), gps2tai.apply(i), i));			
		});
	}
	
	private static Function<String, Double> string2Seconds = s -> {
		Instant instant = LocalDateTime.parse(s).atOffset(ZoneOffset.UTC).toInstant();
		return instant.getEpochSecond() + (double) instant.getNano() / 1_000_000_000;
	};		
		
	private static Function<Double, String> seconds2String = i -> {
		final long seconds = (long) Math.floor(i);
		final int nanos = Math.toIntExact(Math.round(( i - seconds ) * 10_000)) * 100_000;
		return LocalDateTime.ofInstant(Instant.ofEpochSecond(seconds, nanos), ZoneOffset.UTC)
			.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
	};
		
	private static final double UNIX_EPOCH = string2Seconds.apply("1970-01-01T00:00:00");
	private static final double NTP_EPOCH  = string2Seconds.apply("1900-01-01T00:00:00");
	private static final double TAI_EPOCH  = string2Seconds.apply("1958-06-01T00:00:00");
	private static final double GPS_EPOCH  = string2Seconds.apply("1980-01-01T00:00:00");
	
	private static Function<String, Double> utc2unix = s -> string2Seconds.apply(s) - UNIX_EPOCH;		
	private static Function<String, Double> utc2ntp  = s -> string2Seconds.apply(s) + UNIX_EPOCH - NTP_EPOCH;		
	private static Function<Double, Double> ntp2unix = i -> i + NTP_EPOCH - UNIX_EPOCH;	
	private static Function<Double, Double> unix2ntp = i -> i + UNIX_EPOCH - NTP_EPOCH;	
	private static Function<Double, String> unix2utc = i -> seconds2String.apply(i);	
	private static Function<Double, String> ntp2utc  = i -> unix2utc.apply(ntp2unix.apply(i));	
	private static Function<Double, Double> tai2gps  = i -> i + TAI_EPOCH - GPS_EPOCH - 19.0;	
	private static Function<Double, Double> gps2tai  = i -> i + GPS_EPOCH - TAI_EPOCH + 19.0;
		
	private static double ntp2tai(double ntpSeconds) {
	    final double tai = ntpSeconds + NTP_EPOCH - TAI_EPOCH;
	    if ( ntpSeconds < CHANGE_TIMES.getFirst() ) {
	    	return tai;
	    }
	    if ( ntpSeconds >= CHANGE_TIMES.getLast() ) {
	    	return tai + NTP_TO_LS.get(CHANGE_TIMES.getLast());
	    }
	    int i = 0;
	    while ( ntpSeconds >= CHANGE_TIMES.get(i) && i < CHANGE_TIMES.size() ) {
	    	i += 1;
	    }
	    return tai + NTP_TO_LS.get(CHANGE_TIMES.get(i - 1));
	}	
	
	private static double tai2ntp(double taiSeconds) {
	    final double ntp = taiSeconds + TAI_EPOCH - NTP_EPOCH;
	    if ( ntp < CHANGE_TIMES.getFirst() ) {
	    	return ntp;
	    }
	    int index = 0;
	    long delta = 0;
	    if ( ntp >= CHANGE_TIMES.getLast() ) {
	        delta = NTP_TO_LS.get(CHANGE_TIMES.getLast());
	    } else {
	        for ( int i = 1; i < CHANGE_TIMES.size(); i++ ) {
	            if ( ntp < CHANGE_TIMES.get(i) ) {
	                delta = NTP_TO_LS.get(CHANGE_TIMES.get(i - 1));
	                index = i;
	                break;
	            }
	        }
	    }
	    if ( ntp - delta < CHANGE_TIMES.getFirst() ) {
	    	return CHANGE_TIMES.getFirst() - 1 + ntp % 1;
	    }
	    if ( ntp - delta < CHANGE_TIMES.get(index - 1) ) {
	    	return ntp - delta + 1;
	    }
	    return ntp - delta;
	}
		
	private static Function<Double, Double> ntp2gps  = i -> tai2gps.apply(ntp2tai(i)); 	
	private static Function<Double, Double> gps2ntp  = i -> tai2ntp(gps2tai.apply(i));	
	private static Function<Double, Double> tai2unix = i -> ntp2unix.apply(tai2ntp(i));	
	private static Function<Double, Double> unix2tai = i -> ntp2tai(unix2ntp.apply(i));	
	private static Function<Double, String> tai2utc  = i -> ntp2utc.apply(tai2ntp(i));	
	private static Function<String, Double> utc2tai  = s -> ntp2tai(utc2ntp.apply(s));	
	private static Function<Double, Double> gps2unix = i -> tai2unix.apply(gps2tai.apply(i));	
	private static Function<Double, Double> unix2gps = i -> tai2gps.apply(unix2tai.apply(i));	
	private static Function<String, Double> utc2gps  = s -> tai2gps.apply(utc2tai.apply(s));	
	private static Function<Double, String> gps2utc  = i -> tai2utc.apply(gps2tai.apply(i));	
		
	private static final Map<Long, Integer> NTP_TO_LS = Map.ofEntries(
        Map.entry(2272060800L, 10), Map.entry(2287785600L, 11), Map.entry(2303683200L, 12),
	    Map.entry(2335219200L, 13), Map.entry(2366755200L, 14), Map.entry(2398291200L, 15),
	    Map.entry(2429913600L, 16), Map.entry(2461449600L, 17), Map.entry(2492985600L, 18),
	    Map.entry(2524521600L, 19), Map.entry(2571782400L, 20), Map.entry(2603318400L, 21),
	    Map.entry(2634854400L, 22), Map.entry(2698012800L, 23), Map.entry(2776982400L, 24),
	    Map.entry(2840140800L, 25), Map.entry(2871676800L, 26), Map.entry(2918937600L, 27),
	    Map.entry(2950473600L, 28), Map.entry(2982009600L, 29), Map.entry(3029443200L, 30),
	    Map.entry(3076704000L, 31), Map.entry(3124137600L, 32), Map.entry(3345062400L, 33),
	    Map.entry(3439756800L, 34), Map.entry(3550089600L, 35), Map.entry(3644697600L, 36),
	    Map.entry(3692217600L, 37) );
	
	private static final List<Long> CHANGE_TIMES = NTP_TO_LS.keySet().stream().sorted().toList();

}
