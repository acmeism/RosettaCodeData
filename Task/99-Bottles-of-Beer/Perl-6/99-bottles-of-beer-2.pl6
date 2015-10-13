for 99...1 -> $bottles {
    sing $bottles, :wall;
    sing $bottles;
    say  "Take one down, pass it around";
    sing $bottles - 1, :wall;
    say  "";
}

#| Prints a verse about a certain number of beers, possibly on a wall.
sub sing(
    Int $number, #= Number of bottles of beer.
    Bool :$wall, #= Mention that the beers are on a wall?
) {
    my $quantity = $number == 0 ?? "No more"      !! $number;
    my $plural   = $number == 1 ?? ""             !! "s";
    my $location = $wall        ?? " on the wall" !! "";
    say "$quantity bottle$plural of beer$location"
}
