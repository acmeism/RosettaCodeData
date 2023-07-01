use strict;

# $buffer = write_bits(*STDOUT, $buffer, $number, $bits)
sub write_bits :prototype( $$$$ )
{
    my ($out, $l, $num, $q) = @_;
    $l .= substr(unpack("B*", pack("N", $num)),
         -$q);
    if ( (length($l) > 8) ) {
    my $left = substr($l, 8);
    print $out pack("B8", $l);
    $l = $left;
    }
    return $l;
}

# flush_bits(*STDOUT, $buffer)
sub flush_bits :prototype( $$ )
{
    my ($out, $b) = @_;
    print $out pack("B*", $b);
}

# ($val, $buf) = read_bits(*STDIN, $buf, $n)
sub read_bits :prototype( $$$ )
{
    my ( $in, $b, $n ) = @_;
    # we put a limit in the number of bits we can read
    # with one shot; this should mirror the limit of the max
    # integer value perl can hold
    if ( $n > 32 ) { return 0; }
    while ( length($b) < $n ) {
    my $v;
    my $red = read($in, $v, 1);
    if ( $red < 1 ) { return ( 0, -1 ); }
    $b .= substr(unpack("B*", $v), -8);
    }
    my $bits = "0" x ( 32-$n ) . substr($b, 0, $n);
    my $val = unpack("N", pack("B32", $bits));
    $b = substr($b, $n);
    return ($val, $b);
}
