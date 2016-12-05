sub MAIN ($year = Date.today.year) {
    for 1..12 -> $mo {
        my $month-end = Date.new($year, $mo, Date.days-in-month($year, $mo));
        say $month-end - $month-end.day-of-week % 7;
    }
}
