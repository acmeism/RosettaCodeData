use Prime::Factor;

my $start = now;

for flat 600851475143, (1..∞).map: { 2 +< $_ - 1 } {
    say "Largest prime factor of $_: ", max prime-factors $_;
    last if now - $start > 1; # quit after one second of total run time
}
