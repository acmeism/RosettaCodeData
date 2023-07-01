my $buf = "";
my $c;
while( read(*STDIN, $c, 1) > 0 ) {
    $buf = write_bits(*STDOUT, $buf, unpack("C1", $c), 7);
}
flush_bits(*STDOUT, $buf);
