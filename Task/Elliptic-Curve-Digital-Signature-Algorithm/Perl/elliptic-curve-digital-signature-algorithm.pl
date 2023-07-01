use strict;
use warnings;
use Crypt::EC_DSA;

my $ecdsa = Crypt::EC_DSA->new;

my ($pubkey, $prikey) = $ecdsa->keygen;

print "Message: ", my $msg = 'Rosetta Code', "\n";

print "Private Key :\n$prikey \n";
print "Public key  :\n", $pubkey->x, "\n", $pubkey->y, "\n";

my $signature = $ecdsa->sign( Message => $msg, Key => $prikey );
print "Signature   :\n";
for (sort keys %$signature) { print "$_ => $signature->{$_}\n"; }

$ecdsa->verify( Message => $msg, Key => $pubkey, Signature => $signature ) and
   print "Signature verified.\n"
