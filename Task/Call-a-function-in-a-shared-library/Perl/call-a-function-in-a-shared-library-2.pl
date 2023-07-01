use FFI::Platypus;
my $ffi = FFI::Platypus->new;
$ffi->lib(undef);
$ffi->attach(puts => ['string'] => 'int');
$ffi->attach(atan => ['double'] => 'double');

puts(4*atan(1));
