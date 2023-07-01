import java.time.*;
import java.util.stream.*;
import static java.time.temporal.TemporalAdjusters.*;

public class FindTheLastSundayOfEachMonth {
    public static Stream<LocalDate> lastSundaysOf(int year) {
        return IntStream.rangeClosed(1, 12).mapToObj(month ->
            LocalDate.of(year, month, 1).with(lastDayOfMonth())
            .with(previousOrSame(DayOfWeek.SUNDAY))
        );
    }

    public static java.util.List<LocalDate> listLastSundaysOf(int year) {
        return lastSundaysOf(year).collect(Collectors.toList());
    }

    public static void main(String[] args) throws Exception {
        int year = args.length > 0 ? Integer.parseInt(args[0]) : LocalDate.now().getYear();

        for (LocalDate d : listLastSundaysOf(year)) {
            System.out.println(d);
        };

        String result = lastSundaysOf(2013).map(LocalDate::toString).collect(Collectors.joining("\n"));
        String test = "2013-01-27\n2013-02-24\n2013-03-31\n2013-04-28\n2013-05-26\n2013-06-30\n2013-07-28\n2013-08-25\n2013-09-29\n2013-10-27\n2013-11-24\n2013-12-29";
        if (!test.equals(result)) throw new AssertionError("test failure");
    }

}
