#= Sings a verse about a certian number of beers, possibly on a wall.
sub sing(
    Int $number, #= Number of bottles of beer.
    Bool $has_wall = False #= Mention that the beers are on a wall?
) {
    my $quantity = $number == 0 ?? "No more" !! $number;
    my $plural = $number == 1 ?? "" !! "s";
    my $wall = $has_wall ?? " on the wall" !! "";
    return "{$quantity} bottle{$plural} of beer{$wall}"
}

for 99...1 -> $bottles {
    .say for
        sing($bottles, True),
        sing($bottles),
        "Take one down, pass it around",
        sing($bottles-1, True),
        "";
}
