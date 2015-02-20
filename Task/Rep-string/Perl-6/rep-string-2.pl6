sub repstr(Str $s) {
    my $bits = :2($s);
    for reverse 1 .. $s.chars div 2 -> $left {
	my $right = $s.chars - $left;
	return $left if $bits +^ ($bits +> $left) == $bits +> $right +< $right;
    }
}


for '1001110011 1110111011 0010010010 1010101010 1111111111 0100101101 0100100 101 11 00 1'.words {
    if repstr $_ -> $rep {
	say .substr(0,$rep), .substr($rep,$rep).trans('01' => '𝟘𝟙'), .substr($rep*2);
    }
    else {
	say "$_ (no repeat)";
    }
}
