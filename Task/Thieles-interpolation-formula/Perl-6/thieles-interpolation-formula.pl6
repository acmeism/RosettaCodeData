use v6;

# reciprocal difference:
multi sub rho($f, @x where { +@x  < 1 }) { 0 } # Identity
multi sub rho($f, @x where { +@x == 1 }) { $f(@x[0]) }
multi sub rho($f, @x where { +@x  > 1 }) {
  my $ord = +@x;

  return
    ( @x[0] - @x[* -1] )            # ( x - x[n] )
    / ( rho($f, @x[^($ord -1)])     # / ( rho[n-1](x[0], ..., x[n-1])
        - rho($f, @x[1..^($ord)]) ) # - rho[n-1](x[1], ..., x[n]) )
    + rho($f, @x[1..^($ord -1)]);   # + rho[n-2](x[1], ..., x[n-1])
}

# Thiele:
multi sub thiele($x, %f, $ord where { $ord == +%f }) { 1 } # Identity
multi sub thiele($x, %f, $ord) {
  my $f = {%f{$^a}};                # f(x) as a table lookup

  # Caveat: depends on the fact that Rakudo maintains key order within hashes
  my $a = rho($f, %f.keys[^($ord +1)]);
  my $b = rho($f, %f.keys[^($ord -1)]);

  my $num = $x - %f.keys[$ord];
  my $cont = thiele($x, %f, $ord +1);

  # Thiele always takes this form:
  return $a - $b + ( $num / $cont );
}

## Demo
sub mk-inv($fn, $d, $lim) {
  my %h;
  for 0..$lim { %h{ $fn($_ * $d) } = $_ * $d }
  return %h;
}

sub MAIN($tblsz) {
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
