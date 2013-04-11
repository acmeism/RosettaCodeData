my @primes := 2, 3, 5, -> $p { ($p+2, $p+4 ... &prime)[*-1] } ... *;
my @isprime = False,False;  # 0 and 1 are not primes by definition
sub prime($i) { @isprime[$i] //= ($i %% none @primes ...^ * > $_ given $i.sqrt.floor) }

sub ltp {
    for 9...1 -> $a {
        for 9...1 -> $b {
            for 9...1 -> $c {
                for 9...1 -> $d {
                    for 9...1 -> $e {
                        for 9,7,3 -> $f {
                            my @x := [\+] $f, $e, $d, $c, $b, $a Z* (1,10,100 ... *);
                            return @x[*-1] if not grep {not prime $^n}, @x;
                        }
                    }
                }
            }
        }
    }
}

sub infix:<*+> ($a,$b) { $a * 10 + $b }

sub rtp {
    for 7,5,3 {
	for grep &prime, ($_ X*+ 9,7,3,1) {
	    for grep &prime, ($_ X*+ 9,7,3,1) {
		for grep &prime, ($_ X*+ 9,7,3,1) {
		    for grep &prime, ($_ X*+ 9,7,3,1) {
			for grep &prime, ($_ X*+ 9,7,3,1) {
			    return $_;
			}
		    }
		}
	    }
	}
    }
}

say "Highest ltp: ", ltp;
say "Highest rtp: ", rtp;
