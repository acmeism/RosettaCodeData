import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

public final class MayanCalendar {

	public static void main(String[] aArgs) {
		List<LocalDate> testDates = List.of( LocalDate.parse("2004-06-19"),
											 LocalDate.parse("2012-12-18"),
											 LocalDate.parse("2012-12-21"),
											 LocalDate.parse("2019-01-19"),
											 LocalDate.parse("2019-03-27"),
											 LocalDate.parse("2020-02-29"),
											 LocalDate.parse("2020-03-01"),
											 LocalDate.parse("2071-05-16"),
											 LocalDate.parse("2020-02-02") );
		
		System.out.println("Gregorian      Long Count         Tzolk'in    Haab'         Lords of the Night");
		System.out.println("------------------------------------------------------------------------------");
		for ( LocalDate date : testDates ) {
			System.out.println(String.format("%-15s%-19s%-12s%-18s%s",
				date.toString(), longCount(date), tzolkin(date), haab(date), lordsOfTheNight(date)));
		}
	}
	
	private static String lordsOfTheNight(LocalDate aGregorian) {
		long daysBetween = ChronoUnit.DAYS.between(CREATION_TZOLKIN, aGregorian);
		long remainder = Math.floorMod(daysBetween, 9);		
		return "G" + ( ( remainder <= 0 ) ? remainder + 9 : remainder );
	}
	
	private static String longCount(LocalDate aGregorian) {
		long daysBetween = ChronoUnit.DAYS.between(CREATION_TZOLKIN, aGregorian) + 13 * 360 * 400;
		long baktun = Math.floorDiv(daysBetween, 360 * 400);	
		daysBetween = Math.floorMod(daysBetween, 360 * 400);	
		long katun = Math.floorDiv(daysBetween, 20 * 360);	
		daysBetween = Math.floorMod(daysBetween, 20 * 360);
		long tun = Math.floorDiv(daysBetween, 360);	
		daysBetween = Math.floorMod(daysBetween, 360);	
		long winal = Math.floorDiv(daysBetween, 20);	
		long kin = Math.floorMod(daysBetween, 20);
		
		StringBuilder result = new StringBuilder();
		for ( long number : List.of( baktun, katun, tun, winal, kin ) ) {
			String value = String.valueOf(number) + ".";
			result.append( number <= 9 ? "0" + value : value );
		}
		return result.toString().substring(0, result.length() - 1);
	}
	
	private static String haab(LocalDate aGregorian) {
		long daysBetween = ChronoUnit.DAYS.between(ZERO_HAAB, aGregorian);
		int remainder = Math.floorMod(daysBetween, 365);
		String month = Haab.get(Math.floorDiv(remainder + 1, 20));
        int dayOfMonth = Math.floorMod(remainder, 20) + 1;
		return ( dayOfMonth < daysPerMayanMonth(month) ) ? dayOfMonth + " " + month : "Chum " + month;
	}

	private static String tzolkin(LocalDate aGregorian) {
		long daysBetween = ChronoUnit.DAYS.between(CREATION_TZOLKIN, aGregorian);
		int remainder = Math.floorMod(daysBetween, 13);	
		remainder += ( remainder <= 9 ) ? 4 : -9;
		return remainder + " " + Tzolkin.get(Math.floorMod(daysBetween - 1, 20));
	}
	
	private static int daysPerMayanMonth(String aMonth) {
		return ( aMonth == "Wayeb'" ) ? 5 : 20;
	}
	
	private static List<String> Tzolkin = List.of( "Imix'", "Ik'", "Ak'bal", "K'an", "Chikchan", "Kimi", "Manik'",
		"Lamat", "Muluk", "Ok", "Chuwen", "Eb", "Ben", "Hix", "Men", "K'ib'", "Kaban", "Etz'nab'", "Kawak", "Ajaw" );

	private static List<String> Haab = List.of( "Pop", "Wo'", "Sip", "Sotz'", "Sek", "Xul", "Yaxk'in", "Mol",
		"Ch'en", "Yax", "Sak'", "Keh", "Mak", "K'ank'in", "Muwan", "Pax", "K'ayab", "Kumk'u", "Wayeb'" );
	
	private static final LocalDate CREATION_TZOLKIN = LocalDate.parse("2012-12-21");
	private static final LocalDate ZERO_HAAB = LocalDate.parse("2019-04-02");

}
