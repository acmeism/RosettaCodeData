import java.time.LocalDate;
import java.util.List;

public final class DayOfWeekOfChristmasAndNewYear {

	public static void main(String[] args) {
		List<Integer> years = List.of( 1578, 1590, 1642, 1957, 2020, 2021, 2022, 2242, 2245, 2393 );
		
		years.forEach( year -> {
			LocalDate newYear = LocalDate.of(year, 01, 01);
			LocalDate christmas = LocalDate.of(year, 12, 25);
			
			if ( newYear.isBefore(GREGORIAN_CALENDAR_START) ) {
				newYear = newYear.plusDays(10);
			}			
			if ( christmas.isBefore(GREGORIAN_CALENDAR_START) ) {
				christmas = christmas.plusDays(10);
			}
			System.out.println("In " + year + ", New Years Day is a " + newYear.getDayOfWeek()
				               + " and Christmas Day is a " + christmas.getDayOfWeek());			
		} );
	}
	
	private static final LocalDate GREGORIAN_CALENDAR_START = LocalDate.of(1582, 02, 24);

}
