using System;

public static class DiscordianDate
{
    static readonly string[] seasons = { "Chaos", "Discord", "Confusion", "Bureaucracy", "The Aftermath" };
    static readonly string[] weekdays = { "Sweetmorn", "Boomtime", "Pungenday", "Prickle-Prickle", "Setting Orange" };
    static readonly string[] apostles = { "Mungday", "Mojoday", "Syaday", "Zaraday", "Maladay" };
    static readonly string[] holidays = { "Chaoflux", "Discoflux", "Confuflux", "Bureflux", "Afflux" };

    public static string Discordian(this DateTime date) {
        string yold = $" in the YOLD {date.Year + 1166}.";
        int dayOfYear = date.DayOfYear;

        if (DateTime.IsLeapYear(date.Year)) {
            if (dayOfYear == 60) return "St. Tib's day" + yold;
            else if (dayOfYear > 60) dayOfYear--;
        }
        dayOfYear--;

        int seasonDay = dayOfYear % 73 + 1;
        int seasonNr = dayOfYear / 73;
        int weekdayNr = dayOfYear % 5;
        string holyday = "";

        if (seasonDay == 5)       holyday = $" Celebrate {apostles[seasonNr]}!";
        else if (seasonDay == 50) holyday = $" Celebrate {holidays[seasonNr]}!";
        return $"{weekdays[weekdayNr]}, day {seasonDay} of {seasons[seasonNr]}{yold}{holyday}";
    }

    public static void Main() {
        foreach (var (day, month, year) in new [] {
            (1, 1, 2010),
            (5, 1, 2010),
            (19, 2, 2011),
            (28, 2, 2012),
            (29, 2, 2012),
            (1, 3, 2012),
            (19, 3, 2013),
            (3, 5, 2014),
            (31, 5, 2015),
            (22, 6, 2016),
            (15, 7, 2016),
            (12, 8, 2017),
            (19, 9, 2018),
            (26, 9, 2018),
            (24, 10, 2019),
            (8, 12, 2020),
            (31, 12, 2020)
        })
        {
            Console.WriteLine($"{day:00}-{month:00}-{year:00} = {new DateTime(year, month, day).Discordian()}");
        }
    }

}
