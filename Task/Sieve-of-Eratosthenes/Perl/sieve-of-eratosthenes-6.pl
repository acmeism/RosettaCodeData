sub sieve{ my (@s, $i);
	grep { not $s[ $i  = $_ ] and do
		 { $s[ $i += $_ ]++ while $i <= $_[0]; 1 }
	} 2..$_[0]
}

print join ", " => sieve 100;
