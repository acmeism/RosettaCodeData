# Instantiate a specific encoder/decoder.

sub playfair( $key,
              $from = 'J',
	      $to = $from eq 'J' ?? 'I' !! ''
) {

    sub canon($str) { $str.subst(/<-alpha>/,'', :g).uc.subst(/$from/,$to,:g) }

    # Build 5x5 matrix.
    my @m = canon($key ~ ('A'..'Z').join).comb.unique.map:
     -> $a,$b,$c,$d,$e { [$a,$b,$c,$d,$e] }

    # Pregenerate all forward translations.
    my %ENC = gather {
	# Map pairs in same row.
	for @m -> @r {
	    for ^@r X ^@r -> (\i,\j) {
		next if i == j;
		take @r[i] ~ @r[j] => @r[(i+1)%5] ~ @r[(j+1)%5];
	    }
	}

	# Map pairs in same column.
	for ^5 -> $c {
	    my @c = @m.map: *.[$c];
	    for ^@c X ^@c -> (\i,\j) {
		next if i == j;
		take @c[i] ~ @c[j] => @c[(i+1)%5] ~ @c[(j+1)%5];
	    }
	}

	# Map pairs with cross-connections.
	for ^5 X ^5 X ^5 X ^5 -> (\i1,\j1,\i2,\j2) {
	    next if i1 == i2 or j1 == j2;
	    take @m[i1][j1] ~ @m[i2][j2] => @m[i1][j2] ~ @m[i2][j1];
	}
    }

    # Generate reverse translations.
    my %DEC = %ENC.invert;

    return
        sub enc($red) {
	    my @list = canon($red).comb(/(.) (.?) <?{ $1 ne $0 }>/);
	    ~@list.map: { .chars == 1 ?? %ENC{$_~'X'} !! %ENC{$_} }
	},
	sub dec($black) {
	    my @list = canon($black).comb(/../);
	    ~@list.map: { %DEC{$_} }
	}
}

my (&encode,&decode) = playfair 'Playfair example';

my $orig = "Hide the gold in...the TREESTUMP!!!";
say " orig:\t$orig";

my $black = encode $orig;
say "black:\t$black";

my $red = decode $black;
say "  red:\t$red";
