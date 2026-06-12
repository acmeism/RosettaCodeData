my $upto = 1000;

my @ratios = unique (^∞).race.map({($_ / .comb.sum).narrow})[^($upto²)].grep: Int;
my @incons = (sort keys (1..$upto * 10) (-) @ratios)[^$upto];

put "First fifty inconsummate numbers (in base 10):\n" ~ @incons[^50]».fmt("%3d").batch(10).join: "\n";
put "\nOne thousandth: " ~ @incons[999]
