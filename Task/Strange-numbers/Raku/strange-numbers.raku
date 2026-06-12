sub infix:<′>(\x,\y) { abs(x - y) ∈ (2, 3, 5, 7) }

my ($low,$high) = 100, 500;
my @strange.push: $_ if so all .comb.rotor(2 => -1).map: { .[0] ′ .[1] } for $low ^..^ $high;

say "Between $low and $high there are {+@strange} strange numbers:\n";
print @strange.batch(20)».fmt("%4d").join: "\n";
