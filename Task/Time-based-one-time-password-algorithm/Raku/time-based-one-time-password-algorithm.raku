# Reference:
# https://github.com/retupmoca/P6-Digest-HMAC

use v6.d;
use Digest::HMAC;
use Digest::SHA;

sub totp (Str \secret, DateTime \counter, Int \T0=0, Int \T1=30 --> Str) {
   my \key = ( counter - DateTime.new(T0) ).Int div T1;
   return hmac-hex(key.Str, secret, &sha1).substr(0,6) # first 6 chars of sha1
}

my $message = "show me the monKey";

say "Deterministic output at ", DateTime.new(2177452800), " with fixed checks,";
loop (my $t = 2177452800 ; $t < 2177452900 ; $t+= 17 ) { # Y2038 safe
   say totp $message, DateTime.new($t);
}

say "Current time output at ", DateTime.new(now), " with random checks,";
loop (my $n = 0 ; $n < 6 ; $n++, sleep (13..23).roll ) {
   say totp $message, DateTime.new(now);
}
