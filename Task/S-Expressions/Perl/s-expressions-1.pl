use Text::Balanced qw(extract_delimited extract_bracketed);

sub sexpr
{
	my $txt = $_[0];
	$txt =~ s/^\s+//s;
	$txt =~ s/\s+$//s;
	$txt =~ /^\((.*)\)$/s or die "Not an s-expression: <<<$txt>>>";
	$txt = $1;

	my $ret = [];
	my $w;
	while ($txt ne '') {
		my $c = substr $txt,0,1;
		if ($c eq '(') {
			($w, $txt) = extract_bracketed($txt, '()');
			$w = sexpr($w);
		} elsif ($c eq '"') {
			($w, $txt) = extract_delimited($txt, '"');
			$w =~ s/^"(.*)"/$1/;
		} else {
			$txt =~ s/^(\S+)// and $w = $1;
		}
		push @$ret, $w;
		$txt =~ s/^\s+//s;
	}
	return $ret;
}

sub quote
{ (local $_ = $_[0]) =~ /[\s\"\(\)]/s ? do{s/\"/\\\"/gs; qq{"$_"}} : $_; }

sub sexpr2txt
{ qq{(@{[ map { ref($_) eq '' ? quote($_) : sexpr2txt($_) } @{$_[0]} ]})} }
