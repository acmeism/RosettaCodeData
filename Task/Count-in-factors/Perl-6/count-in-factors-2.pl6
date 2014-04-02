sub factor($n is copy) {
    $n == 1 ?? 1 !!
    gather {
	$n /= take 2 while $n %% 2;
	$n /= take 3 while $n %% 3;
	loop (my $p = 5; $p*$p <= $n; $p+=2) {
	    $n /= take $p while $n %% $p;
	}
	take $n unless $n == 1;
    }
}

say "$_ == ", join " \x00d7 ", factor $_ for 1 .. 20;
