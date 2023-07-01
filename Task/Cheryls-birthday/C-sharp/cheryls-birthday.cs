public static class CherylsBirthday
{
    public static void Main() {
        var dates = new HashSet<(string month, int day)> {
            ("May", 15),
            ("May", 16),
            ("May", 19),
            ("June", 17),
            ("June", 18),
            ("July", 14),
            ("July", 16),
            ("August", 14),
            ("August", 15),
            ("August", 17)
        };

        Console.WriteLine(dates.Count + " remaining.");
        //The month cannot have a unique day.
        var monthsWithUniqueDays = dates.GroupBy(d => d.day).Where(g => g.Count() == 1).Select(g => g.First().month).ToHashSet();
        dates.RemoveWhere(d => monthsWithUniqueDays.Contains(d.month));
        Console.WriteLine(dates.Count + " remaining.");
        //The day must now be unique.
        dates.IntersectWith(dates.GroupBy(d => d.day).Where(g => g.Count() == 1).Select(g => g.First()));
        Console.WriteLine(dates.Count + " remaining.");
        //The month must now be unique.
        dates.IntersectWith(dates.GroupBy(d => d.month).Where(g => g.Count() == 1).Select(g => g.First()));
        Console.WriteLine(dates.Single());
    }

}
