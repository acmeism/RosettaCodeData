use Math::BigFloat try => "GMP,Pari";

my $digits = shift || 100;   # Get number of digits from command line
print agm_pi($digits), "\n";

sub agm_pi {
  my $digits = shift;
  my $acc = $digits + 8;
  my $HALF = Math::BigFloat->new("0.5");
  my ($an, $bn, $tn, $pn) = (Math::BigFloat->bone, $HALF->copy->bsqrt($acc),
                             $HALF->copy->bmul($HALF), Math::BigFloat->bone);
  while ($pn < $acc) {
    my $prev_an = $an->copy;
    $an->badd($bn)->bmul($HALF, $acc);
    $bn->bmul($prev_an)->bsqrt($acc);
    $prev_an->bsub($an);
    $tn->bsub($pn * $prev_an * $prev_an);
    $pn->badd($pn);
  }
  $an->badd($bn);
  $an->bmul($an,$acc)->bdiv(4*$tn, $digits);
  return $an;
}
