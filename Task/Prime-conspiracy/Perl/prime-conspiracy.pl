use ntheory qw/forprimes nth_prime/;

my $upto = 1_000_000;
my %freq;
my($this_digit,$last_digit)=(2,0);

forprimes {
  ($last_digit,$this_digit) = ($this_digit, $_ % 10);
  $freq{$last_digit . $this_digit}++;
} 3,nth_prime($upto);

print "$upto first primes.  Transitions prime % 10 → next-prime % 10.\n";
printf "%s → %s count:\t%7d\tfrequency: %4.2f %%\n",
  substr($_,0,1), substr($_,1,1), $freq{$_}, 100*$freq{$_}/$upto
    for sort keys %freq;
