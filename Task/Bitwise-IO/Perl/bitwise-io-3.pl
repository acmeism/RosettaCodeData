my $buf = "";
my $v;
while(1) {
    ( $v, $buf ) = read_bits(*STDIN, $buf, 7);
    last if ($buf < 0);
    print pack("C1", $v);
}
