sub vlq_encode ($number is copy) {
    my @vlq = (127 +& $number).fmt("%02X");
    $number +>= 7;
    while ($number) {
       @vlq.push: (128 +| (127 +& $number)).fmt("%02X");
       $number +>= 7;
    }
    @vlq.reverse.join: ':';
}

sub vlq_decode ($string) {
    sum $string.split(':').reverse.map: {(:16($_) +& 127) +< (7 × $++)}
}

#test encoding and decoding
for (
    0,   0xa,   123,   254,   255,   256,
    257, 65534, 65535, 65536, 65537, 0x1fffff,
    0x200000
 ) -> $testcase {
    printf "%8s %12s %8s\n", $testcase,
      my $encoded = vlq_encode($testcase),
      vlq_decode($encoded);
}
