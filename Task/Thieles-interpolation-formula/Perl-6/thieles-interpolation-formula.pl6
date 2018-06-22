# reciprocal difference:
multi sub ρ(&f, @x where * < 1) { 0 } # Identity
multi sub ρ(&f, @x where * == 1) { &f(@x[0]) }
multi sub ρ(&f, @x where * > 1) {
    ( @x[0] - @x[* - 1] )       # ( x - x[n] )
    / (ρ(&f, @x[^(@x - 1)])     # / ( ρ[n-1](x[0], ..., x[n-1])
    - ρ(&f, @x[1..^@x]) )       # - ρ[n-1](x[1], ..., x[n]) )
    + ρ(&f, @x[1..^(@x - 1)]);  # + ρ[n-2](x[1], ..., x[n-1])
}

# Thiele:
multi sub thiele($x, %f, $ord where { $ord == +%f }) { 1 } # Identity
multi sub thiele($x, %f, $ord) {
  my &f = {%f{$^a}};                # f(x) as a table lookup

  # must sort hash keys to maintain order between invocations
  my $a = ρ(&f, %f.keys.sort[^($ord +1)]);
  my $b = ρ(&f, %f.keys.sort[^($ord -1)]);

  my $num = $x - %f.keys.sort[$ord];
  my $cont = thiele($x, %f, $ord +1);

  # Thiele always takes this form:
  return $a - $b + ( $num / $cont );
}

## Demo
sub mk-inv(&fn, $d, $lim) {
  my %h;
  for 0..$lim { %h{ &fn($_ * $d) } = $_ * $d }
  return %h;
}

sub MAIN($tblsz = 12) {
  my %invsin = mk-inv(&sin, 0.05, $tblsz);
  my %invcos = mk-inv(&cos, 0.05, $tblsz);
  my %invtan = mk-inv(&tan, 0.05, $tblsz);

  my $sin_pi = 6 * thiele(0.5, %invsin, 0);
  my $cos_pi = 3 * thiele(0.5, %invcos, 0);
  my $tan_pi = 4 * thiele(1.0, %invtan, 0);

  say "pi = {pi}";
  say "estimations using a table of $tblsz elements:";
  say "sin interpolation: $sin_pi";
  say "cos interpolation: $cos_pi";
  say "tan interpolation: $tan_pi";
}
