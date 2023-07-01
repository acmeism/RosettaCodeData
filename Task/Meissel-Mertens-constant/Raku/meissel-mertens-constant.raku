# 20221011 Raku programming solution

my $s;
.is-prime and $s += log(1-1/$_)+1/$_ for 2 .. 10**8;
say $s + .57721566490153286
