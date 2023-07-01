use strict;
use warnings;
use feature 'say';

sub area_by_shoelace {
    my $area;
    our @p;
    $#_ > 0 ? @p = @_ : (local *p = shift);
    $area += $p[$_][0] * $p[($_+1)%@p][1] for 0 .. @p-1;
    $area -= $p[$_][1] * $p[($_+1)%@p][0] for 0 .. @p-1;
    return abs $area/2;
}

my @poly = ( [3,4], [5,11], [12,8], [9,5], [5,6] );

say area_by_shoelace(   [3,4], [5,11], [12,8], [9,5], [5,6]   );
say area_by_shoelace( [ [3,4], [5,11], [12,8], [9,5], [5,6] ] );
say area_by_shoelace(  @poly );
say area_by_shoelace( \@poly );
