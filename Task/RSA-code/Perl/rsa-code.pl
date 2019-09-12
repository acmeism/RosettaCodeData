use bigint;

$n = 9516311845790656153499716760847001433441357;
$e = 65537;
$d = 5617843187844953170308463622230283376298685;

package Message {
    my @alphabet;
    push @alphabet, $_ for 'A' .. 'Z', ' ';
    my $rad = +@alphabet;
    $code{$alphabet[$_]} = $_ for 0..$rad-1;

    sub encode {
        my($t) = @_;
        my $cnt = my $sum = 0;
        for (split '', reverse $t) {
            $sum += $code{$_} * $rad**$cnt;
            $cnt++;
        }
        $sum;
    }

    sub decode {
        my($n) = @_;
        my(@i);
        while () {
            push @i, $n % $rad;
            last if  $n < $rad;
            $n = int $n / $rad;
        }
        reverse join '', @alphabet[@i];
    }

    sub expmod {
    my($a, $b, $n) = @_;
    my $c = 1;
    do {
        ($c *= $a) %= $n if $b % 2;
        ($a *= $a) %= $n;
    } while ($b = int $b/2);
    $c;
}

}

my $secret_message = "ROSETTA CODE";

$numeric_message  = Message::encode $secret_message;
$numeric_cipher   = Message::expmod $numeric_message, $e, $n;
$text_cipher      = Message::decode $numeric_cipher;
$numeric_cipher2  = Message::encode $text_cipher;
$numeric_message2 = Message::expmod $numeric_cipher2, $d, $n;
$secret_message2  = Message::decode $numeric_message2;

print <<"EOT";
Secret message is $secret_message
Secret message in integer form is $numeric_message
After exponentiation with public exponent we get: $numeric_cipher
This turns into the string $text_cipher
If we re-encode it in integer form we get $numeric_cipher2
After exponentiation with SECRET exponent we get: $numeric_message2
This turns into the string $secret_message2
EOT
