use strict;
use warnings;
use feature 'say';
use List::Util 'reduce';
use Math::AnyNum ':overload';
local $Math::AnyNum::PREC = 845;

my(@S,$sum);
push @S, 1 + reduce { $a * $b } @S for 0..10;
shift @S;
$sum += 1/$_ for @S;

say "First 10 elements of Sylvester's sequence: @S";
say "\nSum of the reciprocals of first 10 elements: " . float $sum;
