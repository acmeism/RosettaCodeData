sub transpose(@m)
{
    my @t;
    for ^@m X ^@m[0] -> ($x, $y) { @t[$y][$x] = @m[$x][$y] }
    return @t;
}

# creates a random matrix
my @a;
for (^10).pick X (^10).pick -> ($x, $y) { @a[$x][$y] = (^100).pick; }

say "original: ";
.perl.say for @a;

my @b = transpose(@a);

say "transposed: ";
.perl.say for @b;
