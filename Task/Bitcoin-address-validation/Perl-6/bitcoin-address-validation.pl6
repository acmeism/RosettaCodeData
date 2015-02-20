enum B58 <
      1 2 3 4 5 6 7 8 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h i j k   m n o p q r s t u v w x y z
>;

sub unbase58(Str $str) {
    my @out = 0 xx 25;
    for B58.enums.hash{$str.comb} {
        my $c = $_;
        for reverse ^25 {
            $c += 58 * @out[$_];
            @out[$_] = $c % 256;
            $c div= 256;
        }
    }
    return @out;
}

sub check-bitcoin-address($addr) {
    use Digest::SHA;
    my @byte = unbase58 $addr;
    !!! 'wrong checksum' unless @byte[21..24] ~~
    sha256(sha256 Buf.new: @byte[0..20]).subbuf(0, 4).list;
}
