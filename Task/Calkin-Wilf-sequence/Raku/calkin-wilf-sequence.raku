my @calkin-wilf = Any, 1, {1 / (.Int × 2 + 1 - $_)} … *;

# Rational to Calkin-Wilf index
sub r2cw (Rat $rat) { :2( join '', flat (flat (1,0) xx *) Zxx reverse r2cf $rat ) }

# The task

say "First twenty terms of the Calkin-Wilf sequence: ",
    @calkin-wilf[1..20]».&prat.join: ', ';

say "\n99991st through 100000th: ",
    (my @tests = @calkin-wilf[99_991 .. 100_000])».&prat.join: ', ';

say "\nCheck reversibility: ", @tests».Rat».&r2cw.join: ', ';

say "\n83116/51639 is at index: ", r2cw 83116/51639;


# Helper subs
sub r2cf (Rat $rat is copy) { # Rational to continued fraction
    gather loop {
	    $rat -= take $rat.floor;
	    last if !$rat;
	    $rat = 1 / $rat;
    }
}

sub prat ($num) { # pretty Rat
    return $num unless $num ~~ Rat|FatRat;
    return $num.numerator if $num.denominator == 1;
    $num.nude.join: '/';
}
