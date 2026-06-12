import java.util.List;

public final class WorthwhileTaskShaving {

	public static void main(String[] args) {
		final int daysInYear = 365;
		final int minute = 60;
		final int hour = 60 * 60;
		final int day = 24 * hour;
		final int week = 7 * day;
		final int year = daysInYear * day;
		final int month = year / 12;		
		
		List<Integer> yearlyUsagefrequencies =
			List.of( 50 * daysInYear, 5 * daysInYear, daysInYear, daysInYear / 7, 12, 1 );
		
		List<Integer> shavedTimesInSeconds = List.of( 1, 5, 30, 60, 300, 1_800, 3_600, 21_600, 86_400 );
		List<String> rowNames = List.of( "1 SECOND", "5 SECONDS", "30 SECONDS", "1 MINUTE",
									     "5 MINUTES", "30 MINUTES", "1 HOUR", "6 HOURS", "1 DAY" );
		
		System.out.println(" ".repeat(31) + "HOW OFTEN YOU DO THE TASK" + System.lineSeparator());
		List<String> columnNames =
			List.of( "SHAVED OFF   | ", "50 / DAY", "5 / DAY", "DAILY", "WEEKLY", "MONTHLY", "YEARLY" );
		columnNames.forEach( columnName -> System.out.print(String.format("%-12s", columnName)) );
		System.out.println(System.lineSeparator() + "-".repeat(87));
		
		final long numberOfYears = 5;
		for ( int y = 0; y < 9; y++ ) {
			System.out.print(String.format("%-12s%s", rowNames.get(y), " | "));
		    for ( int frequency : yearlyUsagefrequencies ) {
		    	final long time = frequency * shavedTimesInSeconds.get(y) * numberOfYears;
		        if ( time < minute ) {
		            displayTime(time, "SECOND");
		        } else if ( time < hour ) {
		            displayTime(time / minute, "MINUTE");
		        } else if ( time < day ) {
		            displayTime(time / hour, "HOUR");
		        } else if ( time < 14 * day ) {
		            displayTime(time / day, "DAY");
		        } else if ( time < 9 * week ) {
		            displayTime(time / week, "WEEK");
		        } else if ( time < year ) {
		            displayTime(time / month, "MONTH");
		        } else {
		            System.out.print(" ".repeat(12));
		        }
		    }
		    System.out.println();
		}
	}
	
	private static void displayTime(long time, String interval) {		
	    String timeString = String.valueOf(time);
	    String plural = ( time == 1 ) ? "" : "S";	
	    System.out.print(String.format("%-12s", timeString + " " + interval + plural));
	}

}
