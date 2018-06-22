class NG {
    has ( $!a1, $!a, $!b1, $!b );
    submethod BUILD ( :$!a1, :$!a, :$!b1, :$!b ) { }

    # Public methods
    method new( $a1, $a, $b1, $b ) { self.bless( :$a1, :$a, :$b1, :$b ) }
    method apply(@cf, :$limit = Inf) {
        (gather {
            map { take self!extract unless self!needterm; self!inject($_) }, @cf;
            take self!drain until self!done;
        })[ ^ $limit ]
    }

    # Private methods
    method !inject ($n) {
        sub xform($n, $x, $y) { $x, $n * $x + $y }
        ( $!a, $!a1 ) = xform( $n, $!a1, $!a );
        ( $!b, $!b1 ) = xform( $n, $!b1, $!b );
    }
    method !extract {
        sub xform($n, $x, $y) { $y, $x - $y * $n }
        my $n = $!a div $!b;
        ($!a,  $!b ) = xform( $n, $!a,  $!b  );
        ($!a1, $!b1) = xform( $n, $!a1, $!b1 );
        $n
    }
    method !drain { $!a = $!a1, $!b = $!b1 if self!needterm; self!extract }
    method !needterm { so [||] !$!b, !$!b1, $!a/$!b != $!a1/$!b1 }
    method !done { not [||] $!b, $!b1 }
}

sub r2cf(Rat $x is copy) { # Rational to continued fraction
    gather loop {
	$x -= take $x.floor;
	last if !$x;
	$x = 1 / $x;
    }
}

sub cf2r(@a) { # continued fraction to Rational
    my $x = @a[* - 1]; # Use FatRats for arbitrary precision
    $x = ( @a[$_- 1] + 1 / $x ).FatRat for reverse 1 ..^ @a;
    $x
}

sub ppcf(@cf) { # format continued fraction for pretty printing
    "[{ @cf.join(',').subst(',',';') }]"
}

sub pprat($a) { # format Rational for pretty printing
   # Use FatRats for arbitrary precision
   $a.FatRat.denominator == 1 ?? $a !! $a.FatRat.nude.join('/')
}

sub test_NG ($rat, @ng, $op) {
    my @cf = $rat.Rat(1e-18).&r2cf;
    my @op = NG.new( |@ng ).apply( @cf );
    say $rat.perl, ' as a cf: ', @cf.&ppcf, " $op = ",
        @op.&ppcf, "\tor ", @op.&cf2r.&pprat, "\n";
}

# Testing
test_NG(|$_) for (
    [ 13/11, [<2 1 0 2>], '+ 1/2 '    ],
    [ 22/7,  [<2 1 0 2>], '+ 1/2    ' ],
    [ 22/7,  [<1 0 0 4>], '/ 4      ' ],
    [ 22/7,  [<7 0 0 22>], '* 7/22   ' ],
    [ 2**.5, [<1 1 0 2>], "\n(1+√2)/2 (approximately)" ]
);

say '100 terms of (1+√2)/2 as a continued fraction and as a rational value:';

my @continued-fraction = NG.new( 1,1,0,2 ).apply( (lazy flat 1, 2 xx * ), limit => 100 );
say @continued-fraction.&ppcf.comb(/ . ** 1..80/).join("\n");
say @continued-fraction.&cf2r.&pprat;
