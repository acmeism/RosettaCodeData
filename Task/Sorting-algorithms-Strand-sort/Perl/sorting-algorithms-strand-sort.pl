use strict;
use warnings;
use feature 'say';

sub merge {
    my ($x, $y) = @_;
    my @out;
    while (@$x and @$y) {
        my $t = $x->[-1] <=> $y->[-1];
        if    ($t == 1)  { unshift @out, pop @$x }
        elsif ($t == -1) { unshift @out, pop @$y }
        else             { splice @out, 0, 0, pop(@$x), pop(@$y) }
    }
    @$x, @$y, @out
}

sub strand {
    my $x = shift;
    my @out = shift @$x // return;
    for (-@$x .. -1) {
        push @out, splice @$x, $_, 1 if $x->[$_] >= $out[-1];
    }
    @out
}

sub strand_sort {
    my @x = @_;
    my(@out, @strand);
    @out = merge \@out, \@strand while @strand = strand(\@x);
    @out
}

my @a = map (int rand(100), 1 .. 10);
say "Before @a";
@a = strand_sort(@a);
say "After  @a";
