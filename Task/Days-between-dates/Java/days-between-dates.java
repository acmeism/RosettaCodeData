import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class DaysBetweenDates {
    public static void main(String[] args) {
        LocalDate fromDate = LocalDate.parse("2019-01-01");
        LocalDate toDate = LocalDate.parse("2019-10-19");
        long diff = ChronoUnit.DAYS.between(fromDate, toDate);
        System.out.printf("Number of days between %s and %s: %d\n", fromDate, toDate, diff);
    }
}
