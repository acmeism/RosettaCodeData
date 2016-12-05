sub transpose(@m)
{
    my @t;
    for ^@m X ^@m[0] -> ($x, $y) { @t[$y][$x] = @m[$x][$y] }
    return @t;
}

# creates a random matrix
my @a;
for ^5 X ^5 -> ($x, $y) { @a[$x][$y] = ('a'..'z').pick; }
say "original:";
.gist.say for @a;

my @b = transpose(@a);
say "transposed:";
.gist.say for @b;
