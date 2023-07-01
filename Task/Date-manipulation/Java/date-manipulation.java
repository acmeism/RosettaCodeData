import java.time.*;
import java.time.format.*;

class Main {
  public static void main(String args[]) {
    String dateStr = "March 7 2009 7:30pm EST";

    DateTimeFormatter df = new DateTimeFormatterBuilder()
				.parseCaseInsensitive()
				.appendPattern("MMMM d yyyy h:mma zzz")
				.toFormatter();
		
    ZonedDateTime after12Hours = ZonedDateTime.parse(dateStr, df).plusHours(12);

    System.out.println("Date: " + dateStr);
    System.out.println("+12h: " + after12Hours.format(df));

    ZonedDateTime after12HoursInCentralEuropeTime = after12Hours.withZoneSameInstant(ZoneId.of("CET"));
    System.out.println("+12h (in Central Europe): " + after12HoursInCentralEuropeTime.format(df));
  }
}
