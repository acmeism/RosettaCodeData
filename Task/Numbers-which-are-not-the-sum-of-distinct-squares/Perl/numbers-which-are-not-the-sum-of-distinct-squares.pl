use v5.36;
use List::Util <sum uniq none>;
use Algorithm::Combinatorics 'combinations';

my @squares = map { $_**2 } 0..100;
my $sq;

while (++$sq) {
    my(@sums, @run);
    for (1..$sq) {
        push @sums, sum @squares[@$_] for combinations [1..$sq+1], $_
    }
    @sums = uniq sort { $a <=> $b } @sums;
    for (@sums) {
        push(@run, $_) and next unless @run;
        if ($_ == $run[-1] + 1) { push @run, $_ } else { last if @run > $squares[$sq]; @run = () }
    }
    next unless @run;
    for my $i (1..$run[-1]) {
         push @res, $i if none { $i eq $_ } @sums
    }
    last if @run > $squares[$sq];
}
