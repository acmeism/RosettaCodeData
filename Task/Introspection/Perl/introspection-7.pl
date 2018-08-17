use 5.010;
use Regexp::Common;
use List::Util qw(sum);
my @ints = grep { /^$RE{num}{int}$/ } map { $$_ // '' } values %::;
my $num = @ints;
my $sum = sum @ints;
say "$num integers, sum = $sum";
