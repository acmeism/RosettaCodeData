sub is_pernicious {
    my $n = shift;
    my $c = 2693408940;  # primes < 32 as set bits
    while ($n) { $c >>= 1; $n &= ($n - 1); }
    $c & 1;
}

my ($i, @p) = 0;
while (@p < 25) {
    push @p, $i if is_pernicious($i);
    $i++;
}

print join ' ', @p;
print "\n";
($i, @p) = (888888877,);
while ($i < 888888888) {
    push @p, $i if is_pernicious($i);
    $i++;
}

print join ' ', @p;
