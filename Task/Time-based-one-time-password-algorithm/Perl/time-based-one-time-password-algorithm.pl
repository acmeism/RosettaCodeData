# 20200704 added Perl programming solution

use strict;
use warnings;

use Authen::OATH;

my $message = "show me the monKey"; # convert to base32 is optional

my $oath = Authen::OATH->new(); # default SHA1 and TI=30

for ( my $t = 2177452800 ; $t < 2177452919 ; $t += 13 ) {
   print "At ", scalar gmtime $t, " : ", $oath->totp( $message, $t ), "\n" ;
}
