use ntheory qw/factor/;
print "$_ = ", join(" x ", factor($_)), "\n" for 1000000000000000000 .. 1000000000000000010;
