use SSL::Digest;

constant BASE58 = <
      1 2 3 4 5 6 7 8 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h i j k   m n o p q r s t u v w x y z
>;

sub encode( UInt $n ) {
    [R~] BASE58[ $n.polymod: 58 xx * ]
}

sub public_point_to_address( UInt $x, UInt $y ) {
    my @bytes = (
        |$y.polymod( 256 xx 32 )[^32], # ignore the extraneous 33rd modulus
        |$x.polymod( 256 xx 32 )[^32],
    );
    my $hash = rmd160 sha256 Blob.new: 4, @bytes.reverse;
    my $checksum = sha256(sha256 Blob.new: 0, $hash.list).subbuf: 0, 4;
    encode reduce * * 256 + * , flat 0, ($hash, $checksum)».list
}

say public_point_to_address
0x50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352,
0x2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6;
