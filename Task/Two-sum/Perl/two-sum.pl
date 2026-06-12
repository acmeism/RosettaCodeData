use strict;
use warnings;
use feature 'say';

sub two_sum{
  my($sum,@numbers) = @_;
  my $i = 0;
  my $j = $#numbers - 1;
  my @indices;
  while ($i < $j) {
    if    ($numbers[$i] + $numbers[$j] == $sum) { push @indices, ($i, $j); $i++; }
    elsif ($numbers[$i] + $numbers[$j]  < $sum) { $i++ }
    else                                        { $j-- }
  }
  return @indices
}

my @numbers = <0 2 11 19 90>;
my @indices = two_sum(21, @numbers);
say join(', ', @indices) || 'No match';

@indices = two_sum(25, @numbers);
say join(', ', @indices) || 'No match';
