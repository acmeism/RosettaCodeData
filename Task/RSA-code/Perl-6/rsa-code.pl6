constant $n = 9516311845790656153499716760847001433441357;
constant $e = 65537;
constant $d = 5617843187844953170308463622230283376298685;

my $secret-message = "ROSETTA CODE";

package Message {
    my @alphabet = slip('A' .. 'Z'), ' ';
    my $rad = +@alphabet;
    my %code = @alphabet Z=> 0 .. *;
    subset Text of Str where /^^ @alphabet+ $$/;
    our sub encode(Text $t) {
	[+] %code{$t.flip.comb} Z* (1, $rad, $rad*$rad ... *);
    }
    our sub decode(Int $n is copy) {
	@alphabet[
	    gather loop {
		take $n % $rad;
		last if $n < $rad;
		$n div= $rad;
	    }
	].join.flip;
    }
}

use Test;
plan 1;

say "Secret message is $secret-message";
say "Secret message in integer form is $_" given
    my $numeric-message = Message::encode $secret-message;
say "After exponentiation with public exponent we get: $_" given
    my $numeric-cipher = expmod $numeric-message, $e, $n;
say "This turns into the string $_" given
    my $text-cipher = Message::decode $numeric-cipher;

say "If we re-encode it in integer form we get $_" given
    my $numeric-cipher2 = Message::encode $text-cipher;
say "After exponentiation with SECRET exponent we get: $_" given
    my $numeric-message2 = expmod $numeric-cipher2, $d, $n;
say "This turns into the string $_" given
    my $secret-message2 = Message::decode $numeric-message2;

is $secret-message, $secret-message2, "the message has been correctly decrypted";
