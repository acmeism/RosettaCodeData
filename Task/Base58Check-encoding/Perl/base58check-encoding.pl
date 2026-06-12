use Math::BigInt;

sub encode_base58 {
    my ($num) = @_;
    $num = Math::BigInt->new($num);

    my $chars = [qw(
    1 2 3 4 5 6 7 8 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h i j k   m n o p q r s t u v w x y z
    )];

    my $base58;
    while ($num->is_pos) {
        my ($quotient, $remainder) = $num->bdiv(58);
        $base58 = $chars->[$remainder] . $base58;
    }
    $base58
}

printf "%56s -> %s\n", $_, encode_base58(+$_)
    for qw(
     25420294593250030202636073700053352635053786165627414518
     0x61
     0x626262
     0x636363
     0x73696d706c792061206c6f6e6720737472696e67
     0x516b6fcd0f
     0xbf4f89001e670274dd
     0x572e4794
     0xecac89cad93923c02321
     0x10c8511e
    );
