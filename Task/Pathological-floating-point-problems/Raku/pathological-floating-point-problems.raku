say '1st: Convergent series';
my @series = 2.FatRat, -4, { 111 - 1130 / $^v + 3000 / ( $^v * $^u ) } ... *;
for flat 3..8, 20, 30, 50, 100 -> $n {say "n = {$n.fmt("%3d")} @series[$n-1]"};

say "\n2nd: Chaotic bank society";
sub postfix:<!> (Int $n) { [*] 2..$n } # factorial operator
my $years = 25;
my $balance = sum map { 1 / FatRat.new($_!) }, 1 .. $years + 15; # Generate e-1  to sufficient precision with a Taylor series
put "Starting balance, \$(e-1): \$$balance";
for 1..$years -> $i { $balance = $i * $balance - 1 }
printf("After year %d, you will have \$%1.16g in your account.\n", $years, $balance);

print "\n3rd: Rump's example: f(77617.0, 33096.0) = ";
sub f (\a, \b) { 333.75*b⁶ + a²*( 11*a²*b² - b⁶ - 121*b⁴ - 2 ) + 5.5*b⁸ + a/(2*b) }
say f(77617.0, 33096.0).fmt("%0.16g");
