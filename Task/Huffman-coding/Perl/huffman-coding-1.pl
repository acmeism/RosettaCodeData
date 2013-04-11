sub make_tree {
	my %letters;
	$letters{$_}++ for (split "", shift);
	my (@nodes, $n) = map({ a=>$_, freq=>$letters{$_} }, keys %letters);
	while ((@nodes = sort {	$a->{freq} <=> $b->{freq}
			or $a->{a} cmp $b->{a}	} @nodes) > 1)
	{
		$n = { "0"=>shift(@nodes), "1"=>shift(@nodes) };
		$n->{freq} = $n->{0}{freq} + $n->{1}{freq};
		push @nodes, $n;
	}

	walk($n, "", $n->{tree} = {});
	$n;
}

sub walk {
	my ($n, $s, $h) = @_;
	exists $n->{a} and do {
		print "'$n->{a}': $s\n";
		$h->{$n->{a}} = $s if $h;
		return;
	};
	walk($n->{0}, $s.0, $h);
	walk($n->{1}, $s.1, $h);
}

sub encode {
	my ($s, $t) = @_;
	$t = $t->{tree};
	join("", map($t->{$_}, split("", $s)));
}

sub decode {
	my @b = split("", shift);
	my ($n, $out) = $_[0];

	while (@b) {
		$n = $n->{shift @b};
		if ($n->{a}) {
			$out .= $n->{a};
			$n = $_[0];
		}
	}
	$out;
}

my $text = "this is an example for huffman encoding";
my $tree = make_tree($text);
my $e = encode($text, $tree);
print "$e\n";
print decode($e, $tree), "\n";
