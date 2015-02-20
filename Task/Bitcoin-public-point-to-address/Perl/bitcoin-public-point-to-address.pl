use bigint;
use Crypt::RIPEMD160;
use Digest::SHA qw(sha256);
my @b58 = qw{
      1 2 3 4 5 6 7 8 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h i j k   m n o p q r s t u v w x y z
};
my $b58 = qr/[@{[join '', @b58]}]/x;

sub encode { my $_ = shift; $_ < 58 ? $b58[$_] : encode($_/58) . $b58[$_%58] }

sub public_point_to_address {
    my ($x, $y) = @_;
    my @byte;
    for (1 .. 32) { push @byte, $y % 256; $y /= 256 }
    for (1 .. 32) { push @byte, $x % 256; $x /= 256 }
    @byte = (4, reverse @byte);
    my $hash = Crypt::RIPEMD160->hash(sha256 join '', map { chr } @byte);
    my $checksum = substr sha256(sha256 chr(0).$hash), 0, 4;
    my $value = 0;
    for ( (chr(0).$hash.$checksum) =~ /./gs ) { $value = $value * 256 + ord }
    (sprintf "%33s", encode $value) =~ y/ /1/r;
}

print public_point_to_address map {hex "0x$_"} <DATA>;

__DATA__
50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352
2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6
