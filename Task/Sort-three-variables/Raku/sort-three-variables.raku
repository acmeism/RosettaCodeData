# Sorting strings. Added a vertical bar between strings to make them discernable
my ($a, $b, $c) = 'lions, tigers, and', 'bears,  oh my!', '(from "The Wizard of Oz")';
say "sorting: {($a, $b, $c).join('|')}";
say ($a, $b, $c).sort.join('|'), ' - standard lexical string sort';

# Sorting numeric things
my ($x, $y, $z) = 7.7444e4, -12, 18/2;
say "\nsorting: $x $y $z";
say ($x, $y, $z).sort, ' - standard numeric sort, low to high';

# Or, with a modified comparitor:
for  -*,       ' - numeric sort high to low',
     ~*,       ' - lexical "string" sort',
     *.chars,  ' - sort by string length short to long',
     -*.chars, ' - or long to short'
  -> $comparitor, $type {
    my ($x, $y, $z) = 7.7444e4, -12, 18/2;
    say ($x, $y, $z).sort( &$comparitor ), $type;
}
say '';

# sort ALL THE THINGS
# sorts by lexical order with numeric values by magnitude.
.say for ($a, $b, $c, $x, $y, $z).sort;
