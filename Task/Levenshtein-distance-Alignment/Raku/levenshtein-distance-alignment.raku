sub align ( Str $σ, Str $t ) {
    my @s = flat *, $σ.comb;
    my @t = flat *, $t.comb;

    my @A;
    @A[$_][ 0]<d s t> = $_, @s[1..$_].join, '-' x $_ for ^@s;
    @A[ 0][$_]<d s t> = $_, '-' x $_, @t[1..$_].join for ^@t;

    for 1 ..^ @s X 1..^ @t -> (\i, \j) {
	if @s[i] ne @t[j] {
	    @A[i][j]<d> = 1 + my $min =
	    min @A[i-1][j]<d>, @A[i][j-1]<d>, @A[i-1][j-1]<d>;
	    @A[i][j]<s t> =
	    @A[i-1][j]<d> == $min ??  (@A[i-1][j]<s t> Z~ @s[i], '-') !!
	    @A[i][j-1]<d> == $min ??  (@A[i][j-1]<s t> Z~ '-', @t[j]) !!
	    (@A[i-1][j-1]<s t> Z~ @s[i], @t[j]);
	} else {
	    @A[i][j]<d s t> = @A[i-1][j-1]<d s t> Z~ '', @s[i], @t[j];
	}
    }

    return @A[*-1][*-1]<s t>;
}

.say for align 'rosettacode', 'raisethysword';
