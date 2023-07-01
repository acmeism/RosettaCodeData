# 20200814 added Perl programming solution

use strict;
use warnings;

use Crypt::OTP;
use Bytes::Random::Secure qw( random_bytes );

print "Message     : ", my $message = "show me the monKey", "\n";

my $otp = random_bytes(length $message);
print "Ord(OTP)    : ", ( map { ord($_).' ' } (split //, $otp)   ) , "\n";

my $cipher = OTP( $otp, $message, 1 );
print "Ord(Cipher) : ", ( map { ord($_).' ' } (split //, $cipher) ) , "\n";

print "Decoded     : ",  OTP( $otp, $cipher, 1 ), "\n";
