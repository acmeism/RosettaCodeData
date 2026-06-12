use strict;
use warnings;
use feature 'say';
use List::AllUtils <min firstidx>;

my @list = <6 81 243 14 25 49 123 69 11>;
say " Original @list";
push @list, get(min @list) + get(min @list) and say "@list" while @list > 1;

sub get {
    my($min) = @_;
    splice @list, (firstidx { $min == $_ } @list), 1;
    printf " %3d ", $min;
    $min;
}
