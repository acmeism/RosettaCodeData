# the comma ',' can be used to concatenate arrays:
sub concatenateArrays(@a, @b) {
	@a, @b
}

my @a1 = (1,2,3);
my @a2 = (2,3,4);
concatenateArrays(@a1,@a2).join(", ").say;
