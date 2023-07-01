no warnings 'experimental::signatures';
use feature 'signatures';

sub leonardo ($n, $l0 = 1, $l1 = 1, $add = 1) {
  ($l0, $l1) = ($l1, $l0+$l1+$add)  for 1..$n;
  $l0;
}

my @L = map { leonardo($_) } 0..24;
print "Leonardo[1,1,1]: @L\n";
my @F = map { leonardo($_,0,1,0) } 0..24;
print "Leonardo[0,1,0]: @F\n";
