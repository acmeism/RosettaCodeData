use bignum;
sub pascal_line { $_[0] ? unpack "A(A6)*", 1000001**$_[0] : 1 }
sub pascal { print "@{[map -+-$_, pascal_line $_]}\n" for 0..$_[0]-1 }
