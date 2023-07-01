class RSA-message {
    has ($.n, $.e, $.d); # the 3 elements that define an RSA key

    my @alphabet = |('A' .. 'Z'), ' ';
    my $rad = +@alphabet;
    my %code = @alphabet Z=> 0 .. *;
    subset Text of Str where /^^ @alphabet+ $$/;

    method encode(Text $t) {
        [+] %code{$t.flip.comb} Z× (1, $rad, $rad×$rad … *);
    }

    method decode(Int $n is copy) {
        @alphabet[
            gather loop {
                take $n % $rad;
                last if $n < $rad;
                $n div= $rad;
            }
        ].join.flip;
    }
}

constant $n = 9516311845790656153499716760847001433441357;
constant $e = 65537;
constant $d = 5617843187844953170308463622230283376298685;

my $fmt = "%48s %s\n";

my $message = 'ROSETTA CODE';
printf $fmt, 'Secret message is', $message;

my $rsa = RSA-message.new: n => $n, e => $e, d => $d;
printf $fmt, 'Secret message in integer form is',
    my $numeric-message = $rsa.encode: $message;

printf $fmt, 'After exponentiation with public exponent we get',
    my $numeric-cipher = expmod $numeric-message, $e, $n;

printf $fmt, 'This turns into the string',
    my $text-cipher = $rsa.decode: $numeric-cipher;

printf $fmt, 'If we re-encode it in integer form we get',
    my $numeric-cipher2 = $rsa.encode: $text-cipher;

printf $fmt, 'After exponentiation with SECRET exponent we get',
    my $numeric-message2 = expmod $numeric-cipher2, $d, $n;

printf $fmt, 'This turns into the string',
    my $message2 = $rsa.decode: $numeric-message2;
