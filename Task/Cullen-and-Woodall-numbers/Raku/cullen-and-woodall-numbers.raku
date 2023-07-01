my @cullen  = ^∞ .map: { $_ × 1 +< $_ + 1 };
my @woodall = ^∞ .map: { $_ × 1 +< $_ - 1 };

put "First 20 Cullen numbers: ( n × 2**n + 1)\n",     @cullen[1..20]; # A002064
put "\nFirst 20 Woodall numbers: ( n × 2**n - 1)\n", @woodall[1..20]; # A003261
put "\nFirst 5 Cullen primes: (in terms of n)\n",     @cullen.grep( &is-prime, :k )[^5];  # A005849
put "\nFirst 12 Woodall primes:  (in terms of n)\n", @woodall.grep( &is-prime, :k )[^12]; # A002234
