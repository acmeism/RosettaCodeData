private static string ConvertToCompoundDuration(int seconds)
{
    if (seconds < 0) throw new ArgumentOutOfRangeException(nameof(seconds));
    if (seconds == 0) return "0 sec";

    TimeSpan span = TimeSpan.FromSeconds(seconds);
    int[] parts = {span.Days / 7, span.Days % 7, span.Hours, span.Minutes, span.Seconds};
    string[] units = {" wk", " d", " hr", " min", " sec"};

    return string.Join(", ",
        from index in Enumerable.Range(0, units.Length)
        where parts[index] > 0
        select parts[index] + units[index]);
}
