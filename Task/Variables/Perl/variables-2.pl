my $x = @a;                   # Scalar assignment; $x is set to the
                              # number of elements in @a.
my ($x) = @a;                 # List assignment; $x is set to the first
                              # element of @a.
my @b = @a;                   # List assignment; @b becomes the same length
                              # as @a and each element becomes the same.
my ($x, $y, @b) = @a;         # List assignment; $x and $y get the first
                              # two elements of @a, and @b the rest.
my ($x, $y, @b, @c, $z) = @a; # Same thing, and also @c becomes empty
                              # and $z undefined.
