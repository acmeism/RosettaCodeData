sub MAIN ($year = Date.today.year) {
    for 1..12 -> $month {
        my $month-end = Date.new($year, $month, Date.new($year,$month,1).days-in-month);
        say $month-end - $month-end.day-of-week % 7;
    }
}
