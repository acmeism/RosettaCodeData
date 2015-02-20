import java.text.DateFormatSymbols;
import java.util.*;

public class EasterRelatedHolidays {

    final static Map<String, Integer> holidayOffsets;

    static {
        holidayOffsets = new LinkedHashMap<>();
        holidayOffsets.put("Easter", 0);
        holidayOffsets.put("Ascension", 39);
        holidayOffsets.put("Pentecost", 10);
        holidayOffsets.put("Trinity", 7);
        holidayOffsets.put("Corpus", 4);
    }

    public static void main(String[] args) {
        System.out.println("Christian holidays, related to Easter,"
                + " for each centennial from 400 to 2100 CE:");

        for (int y = 400; y <= 2100; y += 100)
            printEasterRelatedHolidays(y);

        System.out.println("\nChristian holidays, related to Easter,"
                + " for years from 2010 to 2020 CE:");
        for (int y = 2010; y < 2021; y++)
            printEasterRelatedHolidays(y);
    }

    static void printEasterRelatedHolidays(int year) {
        final int a = year % 19;
        final int b = year / 100;
        final int c = year % 100;
        final int d = b / 4;
        final int e = b % 4;
        final int f = (b + 8) / 25;
        final int g = (b - f + 1) / 3;
        final int h = (19 * a + b - d - g + 15) % 30;
        final int i = c / 4;
        final int k = c % 4;
        final int l = (32 + 2 * e + 2 * i - h - k) % 7;
        final int m = (a + 11 * h + 22 * l) / 451;
        final int n = h + l - 7 * m + 114;
        final int month = n / 31 - 1;
        final int day = (n % 31) + 1;

        Calendar date = new GregorianCalendar(year, month, day);
        String[] months = new DateFormatSymbols(Locale.US).getShortMonths();

        System.out.printf("%4d ", year);
        for (String hd : holidayOffsets.keySet()) {
            date.add(Calendar.DATE, holidayOffsets.get(hd));
            System.out.printf("%s: %2d %s  ", hd,
                    date.get(Calendar.DAY_OF_MONTH),
                    months[date.get(Calendar.MONTH)]);
        }
        System.out.println();
    }
}
