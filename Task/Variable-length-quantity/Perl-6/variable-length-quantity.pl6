sub vlq_encode ($number is copy) {
    my $string = '';
    my $t = 0x7F +& $number;
    $number +>= 7;
    $string = $t.chr ~ $string;
    while ($number) {
       $t = 0x7F +& $number;
       $string = (0x80 +| $t).chr ~ $string;
       $number +>= 7;
    }
    return $string;
}

sub vlq_decode ($string is copy) {
    my $number = '0b';
    for $string.ords -> $oct {
        $number ~= ($oct +& 0x7F).fmt("%07b");
    }
    return :2($number);
}

#test encoding and decoding
for (
    0,   0xa,   123,   254,   255,   256,
    257, 65534, 65535, 65536, 65537, 0x1fffff,
    0x200000
 ) -> $testcase {
    my $encoded = vlq_encode($testcase);
    printf "%8s %12s %8s\n", $testcase,
      ( join ':', $encoded.ords>>.fmt("%02X") ),
      vlq_decode($encoded);
}
