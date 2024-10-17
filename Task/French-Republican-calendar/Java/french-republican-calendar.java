import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public final class FrenchRepublicanCalendar {

	public static void main(String[] args) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMMM yyyy");
		
	    List<String> gregorianStrings = List.of(
	    	"22 September 1792", "20 May 1795", "15 July 1799", "23 September 1803", "31 December 1805" );
	
	    List<String> frenchRCStrings = new ArrayList<String>();
	    for ( String gregorianString : gregorianStrings ) {
	        LocalDate gregorianDate = LocalDate.parse(gregorianString, formatter);
	        FrenchRCDate frenchRCDate = FrenchRCDate.toFrenchRCDate(gregorianDate);
	        frenchRCStrings.addLast(frenchRCDate.toString());
	        System.out.println(gregorianString + " => " + frenchRCDate);
	    }
	    System.out.println();
	
	    for ( String frenchRCString : frenchRCStrings ) {
	        FrenchRCDate frenchRCDate = FrenchRCDate.parse(frenchRCString);
	        String gregorianDate = formatter.format(frenchRCDate.toGregorianDate());
	        System.out.println(frenchRCString + " => " + gregorianDate);
	    }
	}
	
}

final class FrenchRCDate {
	
	public FrenchRCDate(int aYear, int aMonth, int aDay) {
        year = aYear; month = aMonth; day = aDay;
    }

	public LocalDate toGregorianDate() {
		final int days = ( year - 1 ) * 365 + additionalDaysForYear(year) + ( month - 1 ) * 30 + day - 1;
		return INTRODUCTION_DATE.plusDays(days);
    }
	
	public String toString() {
        if ( month < 13 ) {
        	return day + " " + MONTHS.get(month - 1) + " " + year;
        }
        return SANSCULOTTIDES.get(day - 1) + " " + year;
	}
	
	public static FrenchRCDate toFrenchRCDate(LocalDate gregorianDate) {
		final int daysBefore = (int) ChronoUnit.DAYS.between(gregorianDate, TERMINATION_DATE);
	    final int daysAfter = (int) ChronoUnit.DAYS.between(INTRODUCTION_DATE, gregorianDate);
	    if ( daysAfter < 0 || daysBefore < 0 ) {
	    	throw new IllegalArgumentException("French Republican Calendar date out of range.");
	    }
	
	    int year = ( daysAfter + 366 ) / 365;
		int days = ( daysAfter + 366 ) % 365 - additionalDaysForYear(year);
		if ( days < 1 ) {
			year -= 1;
			days += 366;
		}
	
		if ( days < 361 ) {
			return new FrenchRCDate(year, days / 30 + 1, days % 30);
		}			
        return new FrenchRCDate(year, 13, days - 360);
	}	
			
	public static FrenchRCDate parse(String frenchRCDate) {
        String[] splits = frenchRCDate.split(" ");
        if ( splits.length == 3 ) {
        	final int year = Integer.valueOf(splits[2]);
            final int month = MONTHS.indexOf(splits[1]) + 1;
            final int day = Integer.valueOf(splits[0]);
            return new FrenchRCDate(year, month, day);
        }

        String yearString = splits[splits.length - 1];
        final int year = Integer.valueOf(yearString);
        String sansculottidesDay = frenchRCDate.substring(0, frenchRCDate.lastIndexOf(" "));
        final int day = SANSCULOTTIDES.indexOf(sansculottidesDay) + 1;
        return new FrenchRCDate(year, 13, day);
	}		

	public static int additionalDaysForYear(int year) {
		return ( year > 11 ) ? 3 : ( year > 7 ) ? 2 : ( year > 3 ) ? 1 : 0;
	}
	
	public static final LocalDate INTRODUCTION_DATE = LocalDate.of(1792, 9, 22);
	public static final LocalDate TERMINATION_DATE = LocalDate.of(1805, 12, 31);
	
	private int year, month, day;

    private static final List<String> MONTHS = List.of(
        "Vendémiaire", "Brumaire", "Frimaire", "Nivôse", "Pluviôse", "Ventôse", "Germinal",
        "Floréal", "Prairial", "Messidor", "Thermidor", "Fructidor", "Sansculottide"
    );

    private static final List<String> SANSCULOTTIDES = List.of(
        "Fête de la vertu", "Fête du génie", "Fête du travail",
        "Fête de l'opinion", "Fête des récompenses", "Fête de la Révolution"
    );	
	
}
