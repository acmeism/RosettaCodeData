sub dec2bin { sprintf "%04b", shift }
sub bin2dec { oct "0b".shift }
sub bin2bits { reverse split(//, substr(shift,0,shift)); }
sub bits2bin { join "", map { 0+$_ } reverse @_ }

sub bxor {
  my($a, $b) = @_;
  (!$a & $b) | ($a & !$b);
}

sub half_adder {
  my($a, $b) = @_;
  ( bxor($a,$b), $a & $b );
}

sub full_adder {
  my($a, $b, $c) = @_;
  my($s1, $c1) = half_adder($a, $c);
  my($s2, $c2) = half_adder($s1, $b);
  ($s2, $c1 | $c2);
}

sub four_bit_adder {
  my($a, $b) = @_;
  my @abits = bin2bits($a,4);
  my @bbits = bin2bits($b,4);

  my($s0,$c0) = full_adder($abits[0], $bbits[0], 0);
  my($s1,$c1) = full_adder($abits[1], $bbits[1], $c0);
  my($s2,$c2) = full_adder($abits[2], $bbits[2], $c1);
  my($s3,$c3) = full_adder($abits[3], $bbits[3], $c2);
  (bits2bin($s0, $s1, $s2, $s3), $c3);
}

print " A    B      A      B   C    S  sum\n";
for my $a (0 .. 15) {
  for my $b (0 .. 15) {
    my($abin, $bbin) = map { dec2bin($_) } $a,$b;
    my($s,$c) = four_bit_adder( $abin, $bbin );
    printf "%2d + %2d = %s + %s = %s %s = %2d\n",
           $a, $b, $abin, $bbin, $c, $s, bin2dec($c.$s);
  }
}
