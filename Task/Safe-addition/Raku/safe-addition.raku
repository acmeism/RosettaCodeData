say "Floating points: (Nums)";
say "Error: " ~ (2**-53).Num;

sub infix:<±+> (Num $a, Num $b) {
    my \ε = (2**-53).Num;
    $a - ε + $b, $a + ε + $b,
}

printf "%4.16f .. %4.16f\n", (1.14e0 ±+ 2e3);

say "\nRationals:";

say ".1 + .2 is exactly equal to .3: ", .1 + .2 === .3;

say "\nLarge denominators require explicit coercion to FatRats:";
say "Sum of inverses of the first 500 natural numbers:";
my $sum = sum (1..500).map: { FatRat.new(1,$_) };
say $sum;
say $sum.nude;

{
    say "\nRat stringification may not show full precision for terminating fractions by default.";
    say "Use a module to get full precision.";
    use Rat::Precise; # module loading is scoped to the enclosing block
    my $rat = 1.5**63;
    say "\nRaku default stringification for 1.5**63:\n" ~ $rat; # standard stringification
    say "\nRat::Precise stringification for 1.5**63:\n" ~$rat.precise; # full precision
}
