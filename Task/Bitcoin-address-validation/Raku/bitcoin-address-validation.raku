sub sha256(blob8 $b) returns blob8 {
  given run <openssl dgst -sha256 -binary>, :in, :out, :bin {
    .in.write: $b;
    .in.close;
    return .out.slurp;
  }
}

my $bitcoin-address = rx/
    << <+alnum-[0IOl]> ** 26..* >>  # an address is at least 26 characters long
    <?{
        .subbuf(21, 4) eq sha256(sha256 .subbuf(0, 21)).subbuf(0, 4) given
        blob8.new: <
            1 2 3 4 5 6 7 8 9
            A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
            a b c d e f g h i j k   m n o p q r s t u v w x y z
        >.pairs.invert.hash{$/.comb}
        .reduce(* * 58 + *)
        .polymod(256 xx 24)
        .reverse;
    }>
/;

say "Here is a bitcoin address: 1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i" ~~ $bitcoin-address;
