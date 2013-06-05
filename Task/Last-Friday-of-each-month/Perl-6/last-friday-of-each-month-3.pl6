sub MAIN (Int $year = Date.today.year) {
    .say for Date.new("$year-01-01") .. Date.new("$year-12-31") ==> classify *.month ==>
             map *.value.reverse.first: *.day-of-week == 5
}
