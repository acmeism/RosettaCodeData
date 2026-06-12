use strict;
use warnings;
use feature 'say';
use enum <False True>;
use ntheory <divisors vecextract>;
use List::AllUtils <sum uniq firstidx>;

sub proper_divisors {
  return 1 if 0 == (my $n = shift);
  my @d = divisors($n);
  pop @d;
  @d
}

sub powerset_sums { uniq map { sum vecextract(\@_,$_) } 1..2**@_-1 }

sub is_practical {
    my($n) = @_;
    return True  if $n == 1;
    return False if 0 != $n % 2;
    ($n-2 == firstidx { $_ == $n-1 } powerset_sums(proper_divisors($n)) ) ? True : False;
}

my @pn;
is_practical($_) and push @pn, $_ for 1..333;
say @pn . " matching numbers:\n" . (sprintf "@{['%4d' x @pn]}", @pn) =~ s/(.{40})/$1\n/gr;
say '';
printf "%6d is practical? %s\n", $_, is_practical($_) ? 'True' : 'False' for 666, 6666, 66666;
