my $limit = 32;

sub powers_of ($radix) { 1, |[\*] $radix xx * }

my @hammings =
  (   powers_of(2)[^ $limit ]       X*
      powers_of(3)[^($limit * 2/3)] X*
      powers_of(5)[^($limit * 1/2)]
   ).sort;

say @hammings[^20];
say @hammings[1690]; # zero indexed
