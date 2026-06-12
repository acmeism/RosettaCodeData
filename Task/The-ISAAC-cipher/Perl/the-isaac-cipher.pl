use warnings;
use strict;
use Math::Random::ISAAC;

my $message = "a Top Secret secret";
my $key = "this is my secret key";

my $enc = xor_isaac($key, $message);
my $dec = xor_isaac($key, join "", pack "H*", $enc);

print "Message: $message\n";
print "Key    : $key\n";
print "XOR    : $enc\n";
print "XOR dcr: ", join("", pack "H*", $dec), "\n";

sub xor_isaac {
  my($key, $msg) = @_;

  # Make an ISAAC stream with the desired seed
  my $rng = Math::Random::ISAAC->new( map { ord } split "",$key );

  # Get ISAAC output in the order the task wants
  my @iranda = map { $_ % 95 + 32 }  # Alpha-tize as the task desires
               reverse               # MRI gives state from the end
               map { $rng->irand }   # Get random inputs...
               0..255;               # a state chunk at a time
  # Encode:
  join "", map { sprintf "%02X",$_ }         # join hex digits
           map { ord($_) ^ shift(@iranda) }  # xor it with rand char
           split "", $msg;                   # Take each character
}
