for <1001110011 1110111011 0010010010 1010101010 1111111111 0100101101 0100100 101 11 00 1> {
    if /^ (.+) $0+: (.*$) <?{ $0.substr(0,$1.chars) eq $1 }> / {
	my $rep = $0.chars;
	say .substr(0,$rep), .substr($rep,$rep).trans('01' => '𝟘𝟙'), .substr($rep*2);
    }
    else {
	say "$_ (no repeat)";
    }
}
