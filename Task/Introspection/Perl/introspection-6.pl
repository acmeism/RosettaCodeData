use 5.010;
package test;
use Regexp::Common;
use List::Util qw(sum);

our $a = 7;
our $b = 1;
our $c = 2;
our $d = -5;
our $e = 'text';
our $f = 0.25;

my @ints = grep { /^$RE{num}{int}$/ } map { $$_ // '' } values %::test::;
my $num = @ints;
my $sum = sum @ints;
say "$num integers, sum = $sum";
