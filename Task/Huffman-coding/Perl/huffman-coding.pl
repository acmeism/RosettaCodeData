use 5.10.0;
use strict;

# produce encode and decode dictionary from a tree
sub walk {
	my ($node, $code, $h, $rev_h) = @_;

	my $c = $node->[0];
	if (ref $c) { walk($c->[$_], $code.$_, $h, $rev_h) for 0,1 }
	else        { $h->{$c} = $code; $rev_h->{$code} = $c }

	$h, $rev_h
}

# make a tree, and return resulting dictionaries
sub mktree {
	my (%freq, @nodes);
	$freq{$_}++ for split '', shift;
	@nodes = map([$_, $freq{$_}], keys %freq);

	do {	# poor man's priority queue
		@nodes = sort {$a->[1] <=> $b->[1]} @nodes;
		my ($x, $y) = splice @nodes, 0, 2;
		push @nodes, [[$x, $y], $x->[1] + $y->[1]]
	} while (@nodes > 1);

	walk($nodes[0], '', {}, {})
}

sub encode {
	my ($str, $dict) = @_;
	join '', map $dict->{$_}//die("bad char $_"), split '', $str
}

sub decode {
	my ($str, $dict) = @_;
	my ($seg, @out) = ("");

	# append to current segment until it's in the dictionary
	for (split '', $str) {
		$seg .= $_;
		my $x = $dict->{$seg} // next;
		push @out, $x;
		$seg = '';
	}
	die "bad code" if length($seg);
	join '', @out
}

my $txt = 'this is an example for huffman encoding';
my ($h, $rev_h) = mktree($txt);
for (keys %$h) { print "'$_': $h->{$_}\n" }

my $enc = encode($txt, $h);
print "$enc\n";

print decode($enc, $rev_h), "\n";
