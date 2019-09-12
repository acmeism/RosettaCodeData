for (local $_ = "1\n"; s/((.)\2*)//s;) {
	print $1;
	$_ .= ($1 ne "\n" and length($1)).$2
}
