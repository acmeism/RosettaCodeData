sub array {
    my ($x, $y) = @_;
    map {[ (0) x $x ]} 1 .. $y
}

my @square = array 3, 3;

# everything above this line is mostly redundant in perl,
# since perl would have created the array automatically when used.
# however, the above function initializes the array elements to 0,
# while perl would have used undef
#
#  $cube[3][4][5] = 60  # this is valid even if @cube was previously undefined

$square[1][1] = 1;
print "@$_\n" for @square;
> 0 0 0
> 0 1 0
> 0 0 0
