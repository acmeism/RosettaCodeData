use strict;
use warnings;
use feature 'say';

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

sub stern_diatomic {
  my ($p,$q,$i) = (0,1,shift);
  while ($i) {
    if ($i & 1) { $p += $q; } else { $q += $p; }
    $i >>= 1;
  }
  $p;
}

say "First 61 terms of the Fusc sequence:\n" . join ' ', map { stern_diatomic($_) } 0..60;
say "\nIndex and value for first term longer than any previous:";

my $i =  0;
my $l = -1;
while ($l < 5) {
    my $v = stern_diatomic($i);
    printf("%15s : %s\n", comma($i), comma($v)) and $l = length $v if length $v > $l;
    $i++;
}
