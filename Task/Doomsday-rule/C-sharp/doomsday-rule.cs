using System;

class Doom {
    public static void Main(string[] args) {
        Date[] dates = {
            new Date(1800,1,6),
            new Date(1875,3,29),
            new Date(1915,12,7),
            new Date(1970,12,23),
            new Date(2043,5,14),
            new Date(2077,2,12),
            new Date(2101,4,2)
        };

        foreach (Date d in dates)
            Console.WriteLine($"{d.Format()}: {d.Weekday()}");
    }
}

class Date {
    private int year, month, day;

    private static readonly int[] leapDoom = {4,1,7,4,2,6,4,1,5,3,7,5};
    private static readonly int[] normDoom = {3,7,7,4,2,6,4,1,5,3,7,5};
    public static readonly string[] weekdays = {
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
    };

    public Date(int year, int month, int day) {
        this.year = year;
        this.month = month;
        this.day = day;
    }

    public bool IsLeapYear() {
        return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
    }

    public string Format() {
        return $"{month:00}/{day:00}/{year:0000}";
    }

    public string Weekday() {
        int c = year / 100;
        int r = year % 100;
        int s = r / 12;
        int t = r % 12;

        int cAnchor = (5 * (c % 4) + 2) % 7;
        int doom = (s + t + t / 4 + cAnchor) % 7;
        int anchor =
            IsLeapYear() ? leapDoom[month - 1] : normDoom[month - 1];

        return weekdays[(doom + day - anchor + 7) % 7];
    }
}
