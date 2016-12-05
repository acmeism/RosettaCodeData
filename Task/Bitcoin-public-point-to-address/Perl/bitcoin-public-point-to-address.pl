use Crypt::RIPEMD160;
use Digest::SHA qw(sha256);
use Encode::Base58::GMP;

sub public_point_to_address {
    my $ec   = join '', '04', @_;                    # EC: concat x and y to one string and prepend '04' magic value

    my $octets   = pack 'C*', map { hex } unpack('(a2)65', $ec);      # transform the hex values string to octets
    my $hash     = chr(0) . Crypt::RIPEMD160->hash(sha256 $octets);   # perform RIPEMD160(SHA256(octets)
    my $checksum = substr sha256(sha256 $hash), 0, 4;                 # build the checksum
    my $hex      = join '', '0x',                                     # build hex value of hash and checksum
                   map { sprintf "%02X", $_ }
                   unpack 'C*', $hash.$checksum;
    return '1' . sprintf "%32s", encode_base58($hex, 'bitcoin');      # Do the Base58 encoding, prepend "1"
}

say public_point_to_address
    '50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352',
    '2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6'
    ;
