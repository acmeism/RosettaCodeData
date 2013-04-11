use bignum;
sub pascal { $_[0] ? unpack "A(A6)*", 1000001**$_[0] : 1 }
print "@{[map -+-$_, pascal $_]}\n" for 0..22;
