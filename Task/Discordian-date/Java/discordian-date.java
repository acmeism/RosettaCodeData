import java.util.Calendar;
import java.util.GregorianCalendar;

public class DiscordianDate {

    final static String[] seasons = {"Chaos", "Discord", "Confusion",
        "Bureaucracy", "The Aftermath"};

    final static String[] weekday = {"Sweetmorn", "Boomtime", "Pungenday",
        "Prickle-Prickle", "Setting Orange"};

    final static String[] apostle = {"Mungday", "Mojoday", "Syaday",
        "Zaraday", "Maladay"};

    final static String[] holiday = {"Chaoflux", "Discoflux", "Confuflux",
        "Bureflux", "Afflux"};

    public static String discordianDate(final GregorianCalendar date) {
        int y = date.get(Calendar.YEAR) + 1166;
        int m = date.get(Calendar.MONTH);
        int d = date.get(Calendar.DATE);

        if (date.isLeapYear(y) && m == 2 && d == 29)
            return "St. Tib's Day, in the YOLD " + y;

        int dayOfYear = date.get(Calendar.DAY_OF_YEAR);
        if (date.isLeapYear(y) && dayOfYear >= 60)
            dayOfYear--;

        int seasonDay = dayOfYear % 73;
        if (seasonDay == 5)
            return apostle[dayOfYear / 73] + ", in the YOLD " + y;
        if (seasonDay == 50)
            return holiday[dayOfYear / 73] + ", in the YOLD " + y;

        String season = seasons[dayOfYear / 73];
        String dayOfWeek = weekday[(dayOfYear - 1) % 5];

        return String.format("%s, day %s of %s in the YOLD %s",
                dayOfWeek, seasonDay, season, y);
    }

    public static void main(String[] args) {
        System.out.println(discordianDate(new GregorianCalendar()));

        test(2010, 7, 22, "Pungenday, day 57 of Confusion in the YOLD 3176");
        test(2012, 2, 28, "Prickle-Prickle, day 59 of Chaos in the YOLD 3178");
        test(2012, 2, 29, "St. Tib's Day, in the YOLD 3178");
        test(2012, 3, 1, "Setting Orange, day 60 of Chaos in the YOLD 3178");
        test(2010, 1, 5, "Mungday, in the YOLD 3176");
        test(2011, 5, 3, "Discoflux, in the YOLD 3177");
    }

    private static void test(int y, int m, int d, final String result) {
        assert (discordianDate(new GregorianCalendar(y, m, d)).equals(result));
    }
}
