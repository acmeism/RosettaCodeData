use ntheory ":all";
my $t=0;
forfactored { $t++ if @_ > 1 && sumdigits($_) == sumdigits(join "",@_); } 10**8;
say $t;
