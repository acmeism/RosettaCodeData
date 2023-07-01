use ntheory qw/is_prime hammingweight/;
my $i = 1;
my @pern = map { $i++ while !is_prime(hammingweight($i)); $i++; } 1..25;
print "@pern\n";
print join(" ", grep { is_prime(hammingweight($_)) } 888888877 .. 888888888), "\n";
