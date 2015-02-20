my @b58 = qw{
      1 2 3 4 5 6 7 8 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h i j k   m n o p q r s t u v w x y z
};
my %b58 = map { $b58[$_] => $_ } 0 .. 57;

sub unbase58 {
    use integer;
    my @out;
    my $azeroes = length($1) if $_[0] =~ /^(1*)/;
    for my $c ( map { $b58{$_} } $_[0] =~ /./g ) {
        for (my $j = 25; $j--; ) {
            $c += 58 * ($out[$j] // 0);
            $out[$j] = $c % 256;
            $c /= 256;
        }
    }
    my $bzeroes = length($1) if join('', @out) =~ /^(0*)/;
    die "not a 25 byte address\n" if $bzeroes != $azeroes;
    return @out;
}

sub check_bitcoin_address {
    # Does nothing if address is valid
    # dies otherwise
    use Digest::SHA qw(sha256);
    my @byte = unbase58 shift;
    die "wrong checksum\n" unless
    (pack 'C*', @byte[21..24]) eq
    substr sha256(sha256 pack 'C*', @byte[0..20]), 0, 4;
}
