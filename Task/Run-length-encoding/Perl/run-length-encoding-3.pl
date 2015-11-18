sub encode {
    my $str = shift;
    my $ret = "";
    my $nonrep = "";
    while ($str =~ m/(.)\1{0,127}|\z/gs) {
        my $len = length($&);
        if (length($nonrep) && (length($nonrep) == 127 || $len != 1)) {
            $ret .= pack("C", 128 + length($nonrep)) . $nonrep;
            $nonrep = "";
        }
        if    ($len == 1) { $nonrep .= $1 }
        elsif ($len > 1)  { $ret .= pack("C", $len) . $1 }
    }
    return $ret;
}

sub decode {
    my $str = shift;
    my $ret = "";
    for (my $i = 0; $i < length($str);) {
        my $len = unpack("C", substr($str, $i, 1));
        if ($len <= 128) {
            $ret .= substr($str, $i + 1, 1) x $len;
            $i += 2;
        }
        else {
            $ret .= substr($str, $i + 1, $len - 128);
            $i += 1 + $len - 128;
        }
    }
    return $ret;
}
