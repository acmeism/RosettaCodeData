use Math::Factor::XS qw/prime_factors/;
print "$_ = ", join(" x ", prime_factors($_)), "\n" for 1000000000000000000 .. 1000000000000000010;
