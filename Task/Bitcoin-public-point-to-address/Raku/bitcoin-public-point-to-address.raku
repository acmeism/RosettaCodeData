sub dgst(blob8 $b, Str :$dgst) returns blob8 {
  given run «openssl dgst "-$dgst" -binary», :in, :out, :bin {
    .in.write: $b;
    .in.close;
    return .out.slurp;
  }
}
sub sha256($b) { dgst $b, :dgst<sha256> }
sub rmd160($b) { dgst $b, :dgst<rmd160> }

sub public_point_to_address( UInt $x, UInt $y ) {
    my @bytes = flat ($y,$x).map: *.polymod( 256 xx * )[^32];
    my $hash = rmd160 sha256 blob8.new: 4, @bytes.reverse;
    my $checksum = sha256(sha256 blob8.new: 0, $hash.list).subbuf: 0, 4;
    [R~] <
        1 2 3 4 5 6 7 8 9
      A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
      a b c d e f g h i j k   m n o p q r s t u v w x y z
    >[ .polymod: 58 xx * ] given
    reduce * * 256 + * , flat 0, ($hash, $checksum)».list
}

say public_point_to_address
  0x50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352,
  0x2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6;
