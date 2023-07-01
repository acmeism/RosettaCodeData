sub MAIN (Int $year = Date.today.year) {
    say ~.value.reverse.first: *.day-of-week == 5
        for classify *.month, Date.new("$year-01-01") .. Date.new("$year-12-31");
}
