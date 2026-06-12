use strict;
use warnings;
use feature qw<signatures say>;
no warnings qw<experimental::signatures>;
use bigint try => 'GMP';
use ntheory qw<vecprod vecsum vecreduce vecfirstidx>;

sub  f ($n) { vecreduce     { $a * $b } 1,              1..$n }
sub sf ($n) { vecprod   map { f($_) }                   1..$n }
sub  H ($n) { vecprod   map { $_ ** $_ }                1..$n }
sub af ($n) { vecsum    map { (-1) ** ($n-$_) * f($_) } 1..$n }
sub ef ($n) { vecreduce     { $b ** $a }                1..$n }
sub rf ($n) {
    my $v =  vecfirstidx { f($_) >= $n  } 0..1E6;
    $n == f($v) ? $v : 'Nope'
}

say 'sf : ' . join ' ', map { sf $_ } 0..9;
say 'H  : ' . join ' ', map {  H $_ } 0..9;
say 'af : ' . join ' ', map { af $_ } 0..9;
say 'ef : ' . join ' ', map { ef $_ } 1..4;
say '5$ has ' . length(5**4**3**2) . ' digits';
say 'rf : ' . join ' ', map { rf $_ } <1 2 6 24 120 720 5040 40320 362880 3628800>;
say 'rf(119) = ' . rf(119);
