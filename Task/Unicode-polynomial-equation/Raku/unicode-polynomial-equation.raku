# 20251201 Raku programming solution

my @equs = (
   '-0.00x⁺¹⁰ + 1.0·x ** 5 + -2e0x^4 + +0,042.00 × x ⁺³ + +.0x² + 20.000 000 000x¹ - -1x⁺⁰ + .0x⁻¹ + 20.x¹',
   'x⁵ - 2x⁴ + 42x³ + 0x² + 40x + 1',
   '0e+0x⁰⁰⁷ + 00e-00x + 0x + .0x⁰⁵ - 0.x⁴ + 0×x³ + 0x⁻⁰ + 0/x + 0/x³ + 0x⁻⁵',
   '1x⁵ - 2x⁴ + 42x³ + 40x + 1x⁰',
   '+x⁺⁵ + -2x⁻⁻⁴ + 42x⁺⁺³ + +40x - -1',
   'x^5 - 2x**4 + 42x^3 + 40x + 1',
   'x↑5 - 2.00·x⁴ + 42.00·x³ + 40.00·x + 1',
   'x⁻⁵ - 2⁄x⁴ + 42x⁻³ + 40/x + 1x⁻⁰',
   'x⁵ - 2x⁴ + 42.000 000x³ + 40x + 1',
   'x⁵ - 2x⁴ + 0,042x³ + 40.000,000x + 1',
   '0x⁷ + 10x + 10x + x⁵ - 2x⁴ + 42x³ + 20x + 1',
   '1E0x⁵ - 2,000,000.e-6x⁴ + 4.2⏨1x³ + .40e+2x + 1',
   'x⁵ - x⁴⁄2 + 405x³⁄4 + 403x⁄4 + 5⁄2',
   'x⁵ - 0.5x⁴ + 101.25x³ + 100.75x + 2.5',
   'x⁻⁵ - 2⁄x⁴ + 42x⁻³ - 40/x',
   '⅐x⁵ - ⅓x⁴ - ⅔x⁴ + 42⅕x³ + ⅑x - 40⅛ - ⅝',
);

my %powers = < - 0 1 2 3 4 5 6 7 8 9 > Z=> < ⁻ ⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ >;

my %frac-to-dec = ( my %frac = (
   '.25' => '¼', '.5' => '½', '.75' => '¾',   '.2' => '⅕', '.4' => '⅖',
   '.14285714285714285' => '⅐', '.1111111111111111' => '⅑', '.1' => '⅒',
   '.3333333333333333' => '⅓', '.6666666666666666' => '⅔', '.6' => '⅗',
   '.16666666666666666' => '⅙', '.8333333333333334' => '⅚', '.8' => '⅘',
   '.125' => '⅛', '.375' => '⅜', '.625' => '⅝', '.875' => '⅞',
)).antipairs;

sub normalize-exponent(Str $u is copy --> Str) {
   $u .= subst: '⁄', '/', :g;
   $u .= subst: / '⁻⁻' | '⁺⁺' | '**' | '^' | '↑' | '⁺' /, '', :g;
   for %powers.invert { $u .= subst: .key, .value, :g }
   return $u;
}

sub print-equation(%coefs) {
   print "=> ";
   if %coefs.elems == 0 || %coefs.values.all == 0 { say "0\n" andthen return }

   my $first = True;
   for %coefs.keys.map(*.Int).sort: { $^b <=> $^a } -> $p {
      next if ( my $c = %coefs{$p} ) == 0;

      unless $first {
         print " {$c > 0 ?? "+" !! "-"} ";
         $c .= abs
      }

      my $print-coef = ($c.abs != 1 || $p == 0);
      if $print-coef {
         my $cs = $c.Str;
         if $cs.contains('.') {
            my $dec = $cs.substr( $cs.index('.') );
            with %frac{$dec} { $cs .= subst: $dec, $_ }
         }
         if $cs.chars > 1 && $cs.starts-with('0') && $cs.substr(1,1) ne '.' {
            $cs .= substr(1)
         }
         print $cs
      } elsif $c < 0 {
         print "-"
      }

      if $p != 0 {
         my $ps = $p.Str.trans(%powers);
         $ps = "" if $ps eq "¹";
         print "x$ps";
      }
      $first = False;
   }
   say "\n";
}

sub parse-coef(Str $t is copy --> Num) {
   for %frac-to-dec.kv -> $frac, $dec {
      if $t.contains($frac) {
         my $ix = $t.index($frac);
         my $before = $ix > 0 ?? $t.substr(0, $ix) !! "0";
         $before = "0" if $before  eq  any "", "+", "-";
         my $sign = 1;
         if $before.starts-with('-') {
            $sign = -1;
            $before .= substr(1);
         } elsif $before.starts-with('+') {
            $before .= substr(1);
         }
         $before = "0" if $before eq "";
         return $sign * ($before.Num + $dec.Num);
      }
   }
   return $t.Num;
}

my $rgx = rx/ \s+ (<[+-]>) \s+ /;

for @equs -> $equ {
   say $equ;

   my @ops = $equ.match(:g, $rgx)».Str.map: *.trim;
   my @terms = $equ.split($rgx);
   my %coefs;

   for ^@terms -> $i {
      my $term = @terms[$i];
      my $op = ($i > 0 ?? @ops[$i-1] !! Nil);

      my $inverse = False;

      my @s = $term.split("x", 2);
      my $t = @s[0].trans([ '·', '×' ] => [ '', '' ]).trim;

      $t .= subst: / ',' | ' ' /, '', :g;

      $t .= trans( [ '⏨', '⁄', '↉' ] => [ 'e', '/', '.0' ] );

      my Num $c = 1e0;

      if $t eq "" || $t eq "+" || $t eq "-" { $t ~= "1" }

      if $t.ends-with("/") {
         $inverse = True;
         $t .= substr(0, *-1);
         $c = parse-coef($t);
      } elsif $t.contains("/") {
         my ($m, $n) = $t.split("/").map: { parse-coef($_) };
         $c = $m / $n;
      } else {
         $t .= subst(/ '.' $/, '', :g);
         $t .= subst('0.e', '0e', :g);
         $c = parse-coef($t);
      }

      if $i > 0 && $op eq "-" { $c = -$c }
      $c = 0e0 if $c == -0e0;

      my Int $p = 1;

      if @s.elems == 1 {
         %coefs{0} += $c if $c != 0;
         next;
      }

      my $u = normalize-exponent(@s[1].trim);

      my $apply-inverse = False;
      if $u eq "" {
         $p = 1;
         $apply-inverse = True;
      } elsif $u.contains("/") {
         my ($pow-str, $d) = $u.split("/")[0,1]>>.Num;
         $pow-str = "1" if $pow-str eq "";
         $p = $pow-str.Int;
         $c /= $d;
         $apply-inverse = True;
      } else {
         $p = $u.Int;
         $apply-inverse = True;
      }

      $p = -$p if $inverse && $apply-inverse;

      %coefs{$p} += $c if $c != 0;
   }
   print-equation(%coefs);
}
