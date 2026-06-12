my \Δ = $ = 1;
my @magic = flat 0, [1..9], {last if .not; ++Δ; [(.flat X~ 0..9).grep: * %% Δ]}…*;

put "There are {@magic.eager.elems} magic numbers in total.";
put "\nThe largest is {@magic.tail}.";
put "\nThere are:";
put "{(+.value).fmt: "%4d"} with {.key.fmt: "%2d"} digit{1 == +.key ?? '' !! 's'}"
    for sort @magic.classify: {.chars};
{
    my $pan-digital = ($_..9).join.comb.Bag;
    put "\nAll magic numbers that are pan-digital in $_ through 9 with no repeats: " ~
    @magic.grep( { .comb.Bag eqv $pan-digital } );
} for 1, 0;
