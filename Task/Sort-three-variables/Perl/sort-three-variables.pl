#!/usr/bin/env perl
use 5.010_000;

# Sort strings

my $x = 'lions, tigers, and';
my $y = 'bears, oh my!';
my $z = '(from the "Wizard of OZ")';

# When assigning a list to list, the values are mapped
( $x, $y, $z ) = sort ( $x, $y, $z );

say 'Case 1:';
say "  x = $x";
say "  y = $y";
say "  z = $z";

# Sort numbers

$x = 77444;
$y = -12;
$z = 0;

# The sort function can take a customizing block parameter.
# The spaceship operator creates a by-value numeric sort
( $x, $y, $z ) = sort { $a <=> $b } ( $x, $y, $z );

say 'Case 2:';
say "  x = $x";
say "  y = $y";
say "  z = $z";
