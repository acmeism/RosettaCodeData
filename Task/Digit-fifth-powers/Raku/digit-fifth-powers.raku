print q:to/EXPANATION/;
Sum of all integers (except 1 for some mysterious reason ¯\_(ツ)_/¯),
for which the individual digits to the nth power sum to itself.
EXPANATION

sub super($i) { $i.trans('0123456789' => '⁰¹²³⁴⁵⁶⁷⁸⁹') }

for 3..8 -> $power {
    print "\nSum of powers of n{super $power}: ";
    my $threshold = 9**$power * $power;
    put .join(' + '), ' = ', .sum with cache
    (2..$threshold).hyper.map: {
        state %p = ^10 .map: { $_ => $_ ** $power };
        $_ if %p{.comb}.sum == $_
    }
}
