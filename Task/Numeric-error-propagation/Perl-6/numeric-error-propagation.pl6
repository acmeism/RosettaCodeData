# cache of independent sources so we can make them all the same length.
# (Because Perl 6 does not yet have a longest-zip metaoperator.)
my @INDEP;

class Approx does Numeric {
    has Real $.x;	# The mean.
    has $.c;		# The components of error.

    multi method Str  { sprintf "%g±%.3g", $!x, $.σ }
    multi method Bool { abs($!x) > $.σ }

    method variance { [+] @.c X** 2 }
    method σ { sqrt self.variance }
}

multi approx($x,$c) { Approx.new: :$x, :$c }
multi approx($x) { Approx.new: :$x, :c[0 xx +@INDEP] }

# Each ± gets its own source slot.
multi infix:<±>($a, $b) {
    .push: 0 for @INDEP; # lengthen older component lists
    my $c = [ 0 xx @INDEP, $b ];
    @INDEP.push: $c;	 # add new component list

    approx $a, $c;
}

multi prefix:<->(Approx $a) { approx -$a.x, [$a.c.map: -*] }

multi infix:<+>($a, Approx $b) { approx($a) + $b }
multi infix:<+>(Approx $a, $b) { $a + approx($b) }
multi infix:<+>(Approx $a, Approx $b) { approx $a.x + $b.x, [$a.c Z+ $b.c] }

multi infix:<->($a, Approx $b) { approx($a) - $b }
multi infix:<->(Approx $a, $b) { $a - approx($b) }
multi infix:<->(Approx $a, Approx $b) { approx $a.x - $b.x, [$a.c Z- $b.c] }

multi covariance(Real   $a, Real   $b) { 0 }
multi covariance(Approx $a, Approx $b) { [+] $a.c Z* $b.c }

multi infix:«<=>»(Approx $a, Approx $b) { $a.x <=> $b.x }
multi infix:<cmp>(Approx $a, Approx $b) { $a.x <=> $b.x }

multi infix:<*>($a, Approx $b) { approx($a) * $b }
multi infix:<*>(Approx $a, $b) { $a * approx($b) }
multi infix:<*>(Approx $a, Approx $b) {
    approx $a.x * $b.x,
           [$a.c.map({$b.x * $_}) Z+ $b.c.map({$a.x * $_})];
}

multi infix:</>($a, Approx $b) { approx($a) / $b }
multi infix:</>(Approx $a, $b) { $a / approx($b) }
multi infix:</>(Approx $a, Approx $b) {
    approx $a.x / $b.x,
           [ $a.c.map({ $_ / $b.x }) Z+ $b.c.map({ $a.x * $_ / $b.x / $b.x }) ];
}

multi sqrt(Approx $a) {
    my $x = sqrt($a.x);
    approx $x, [ $a.c.map: { $_ / 2 / $x } ];
}

multi infix:<**>(Approx $a, Real $b) { $a ** approx($b) }
multi infix:<**>(Approx $a is copy, Approx $b) {
	my $ax = $a.x;
	my $bx = $b.x;
	my $fbx = floor $b.x;
	if $ax < 0 {
	    if $fbx != $bx or $fbx +& 1 {
		die "Can't take power of negative number $ax";
	    }
	    $a = -$a;
	}
	exp($b * log $a);
}

multi exp(Approx $a) {
	my $x = exp($a.x);
	approx $x, [ $a.c.map: { $x * $_ } ];
}

multi log(Approx $a) {
	my $x0 = $a.x;
	approx log($x0), [ $a.c.map: { $_ / $x0 }];
}

# Each ± sets up an independent source component.
my $x1 = 100 ± 1.1;
my $x2 = 200 ± 2.2;
my $y1 = 50  ± 1.2;
my $y2 = 100 ± 2.3;

# The standard task.
my $z1 = sqrt(($x1 - $x2) ** 2 + ($y1 - $y2) ** 2);
say "distance: $z1\n";

# Just showing off.
my $a = $x1 + $x2;
my $b = $y1 - 2 * $x2;
say "covariance between $a and $b: ", covariance($a,$b);
