# Raku supports multi dimension arrays natively. There are no arbitrary limits on the number of dimensions or maximum indices. Theoretically, you could have an infinite number of dimensions of infinite length, though in practice more than a few dozen dimensions gets unwieldy. An infinite maximum index is a fairly common idiom though. You can assign an infinite lazy list to an array and it will only produce the values when they are accessed.

my @integers = 1 .. Inf; # an infinite array containing all positive integers

say @integers[100000]; #100001 (arrays are zero indexed.)

# Multi dimension arrays may be predeclared which constrains the indices to the declared size:

my @dim5[3,3,3,3,3];

#Creates a preallocated 5 dimensional array where each branch has 3 storage slots and constrains the size to the declared size.
#It can then be accessed like so:

@dim5[0;1;2;1;0] = 'Raku';

say @dim5[0;1;2;1;0]; # prints 'Raku'

#@dim5[0;1;2;1;4] = 'error'; # runtime error: Index 4 for dimension 5 out of range (must be 0..2)

# Note that the dimensions do not _need_ to be predeclared / allocated. Raku will auto-vivify the necessary storage slots on first access.

my @a2;

@a2[0;1;2;1;0] = 'Raku';

@a2[0;1;2;1;4] = 'not an error';

# It is easy to access array "slices" in Raku.

my @b = map { [$_ X~ 1..5] }, <a b c d>;

.say for @b;
# [a1 a2 a3 a4 a5]
# [b1 b2 b3 b4 b5]
# [c1 c2 c3 c4 c5]
# [d1 d2 d3 d4 d5]

say @b[*;2]; # Get the all of the values in the third "column"
# (a3 b3 c3 d3)

# By default, Raku can store any object in an array, and it is not very compact. You can constrain the type of values that may be stored which can allow the optimizer to store them much more efficiently.

my @c = 1 .. 10; # Stores integers, but not very compactly since there are no constraints on what the values _may_ be

my uint16 @d = 1 .. 10 # Since there are and only can be unsigned 16 bit integers, the optimizer will use a much more compact memory layout.

# Indices must be a positive integer. Negative indices are not permitted, fractional indices will be truncated to an integer.
