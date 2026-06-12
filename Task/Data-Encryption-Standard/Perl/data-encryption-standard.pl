use strict;
use warnings;
use Crypt::DES;

my $key        = pack("H*", "0E329232EA6D0D73");
my $cipher     = Crypt::DES->new($key);
my $ciphertext = $cipher->encrypt(pack("H*", "8787878787878787"));
print "Encoded : ", unpack("H*", $ciphertext), "\n";
print "Decoded : ", unpack("H*", $cipher->decrypt($ciphertext)), "\n";
