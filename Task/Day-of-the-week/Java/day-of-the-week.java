import static java.util.Calendar.*;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class Yuletide{
	public static void main(String[] args) {
		Calendar calendar;
        int count = 1;
        for (int year = 2008; year <= 2121; year++) {
            calendar = new GregorianCalendar(year, DECEMBER, 25);
            if (calendar.get(DAY_OF_WEEK) == SUNDAY) {
                if (count != 1)
                    System.out.print(", ");
                System.out.printf("%d", calendar.get(YEAR));
                count++;
            }
        }
	}
}
