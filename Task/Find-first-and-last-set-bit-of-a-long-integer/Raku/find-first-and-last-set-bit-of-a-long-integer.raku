sub table ($base,$power) {
    my $digits = ($base ** $power).chars;
    printf "%{$digits}s  lsb msb\n", 'number';
    for 0..$power {
	my $x = $base ** $_;
	printf "%{$digits}d  %2d  %2d\n", $x, $x.lsb, $x.msb;
    }
}

table 42, 20;
table 1302, 20;
