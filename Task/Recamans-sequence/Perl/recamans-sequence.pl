use bignum;

$max = 1000;
$remaining += $_ for 1..$max;

my @recamans = 0;
my $previous = 0;

while ($remaining > 0) {
   $term++;
   my $this = $previous - $term;
   $this = $previous + $term unless $this > 0 and !$seen{$this};
   push @recamans, $this;
   $dup = $term if !$dup and defined $seen{$this};
   $remaining -= $this if $this <= $max and ! defined $seen{$this};
   $seen{$this}++;
   $previous = $this;
}

print "First fifteen terms of Recaman's sequence: " . join(' ', @recamans[0..14]) . "\n";
print "First duplicate at term: a[$dup]\n";
print "Range 0..1000 covered by terms up to a[$term]\n";
