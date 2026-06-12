sub encode_Base58 ( Int $x ) {
    constant @codes = <
          1 2 3 4 5 6 7 8 9
        A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
        a b c d e f g h i j k   m n o p q r s t u v w x y z
    >;

    return @codes[ $x.polymod( 58 xx * ) ].join.flip;
}

my @tests =
    25420294593250030202636073700053352635053786165627414518 => '6UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM',
    0x61                    => '2g',
    0x626262                => 'a3gV',
    0x636363                => 'aPEr',
    0x73696d706c792061206c6f6e6720737472696e67 => '2cFupjhnEsSn59qHXstmK2ffpLv2',
    0x516b6fcd0f            => 'ABnLTmg',
    0xbf4f89001e670274dd    => '3SEo3LWLoPntC',
    0x572e4794              => '3EFU7m',
    0xecac89cad93923c02321  => 'EJDM8drfXA6uyA',
    0x10c8511e              => 'Rt5zm',
;
use Test;
for @tests {
    is encode_Base58(.key), .value, "{.key} encodes to {.value}";
}
