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
        int y = date.get(Calendar.YEAR);
        int yold = y + 1166;
        int dayOfYear = date.get(Calendar.DAY_OF_YEAR);

        if (date.isLeapYear(y)) {
            if (dayOfYear == 60)
                return "St. Tib's Day, in the YOLD " + yold;
            else if (dayOfYear > 60)
                dayOfYear--;
        }

        dayOfYear--;

        int seasonDay = dayOfYear % 73 + 1;
        if (seasonDay == 5)
            return apostle[dayOfYear / 73] + ", in the YOLD " + yold;
        if (seasonDay == 50)
            return holiday[dayOfYear / 73] + ", in the YOLD " + yold;

        String season = seasons[dayOfYear / 73];
        String dayOfWeek = weekday[dayOfYear % 5];

        return String.format("%s, day %s of %s in the YOLD %s",
                dayOfWeek, seasonDay, season, yold);
    }

    public static void main(String[] args) {

        System.out.println(discordianDate(new GregorianCalendar()));

        test(2010, 6, 22, "Pungenday, day 57 of Confusion in the YOLD 3176");
        test(2012, 1, 28, "Prickle-Prickle, day 59 of Chaos in the YOLD 3178");
        test(2012, 1, 29, "St. Tib's Day, in the YOLD 3178");
        test(2012, 2, 1, "Setting Orange, day 60 of Chaos in the YOLD 3178");
        test(2010, 0, 5, "Mungday, in the YOLD 3176");
        test(2011, 4, 3, "Discoflux, in the YOLD 3177");
        test(2015, 9, 19, "Boomtime, day 73 of Bureaucracy in the YOLD 3181");
    }

    private static void test(int y, int m, int d, final String result) {
        assert (discordianDate(new GregorianCalendar(y, m, d)).equals(result));
    }
}
