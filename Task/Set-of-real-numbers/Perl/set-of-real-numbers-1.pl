use utf8;

# numbers used as boundaries to real sets.  Each has 3 components:
#	the real value x;
#	a +/-1 indicating if it's x + ϵ or x - ϵ
#	a 0/1 indicating if it's the left border or right border
# e.g. "[1.5, ..." is written "1.5, -1, 0", while "..., 2)" is "2, -1, 1"
package BNum;

use overload (
	'""'	=> \&_str,
	'<=>'	=> \&_cmp,
);

sub new {
	my $self = shift;
	bless [@_], ref $self || $self
}

sub flip {
	my @a = @{+shift};
	$a[2] = !$a[2];
	bless \@a
}

my $brackets = qw/ [ ( ) ] /;
sub _str {
	my $v = sprintf "%.2f", $_[0][0];
	$_[0][2]
		? $v . ($_[0][1] == 1 ? "]" : ")")
		: ($_[0][1] == 1 ? "(" : "[" ) . $v;
}

sub _cmp {
	my ($a, $b, $swap) = @_;

	# if one of the argument is a normal number
	if ($swap) { return -_ncmp($a, $b) }
	if (!ref $b || !$b->isa(__PACKAGE__)) { return _ncmp($a, $b) }

	$a->[0] <=> $b->[0] || $a->[1] <=> $b->[1]
}

sub _ncmp {
	# $a is a BNum, $b is something comparable to a real
	my ($a, $b) = @_;
	$a->[0] <=> $b || $a->[1] <=> 0
}

package RealSet;
use Carp;
use overload (
	'""'	=> \&_str,
	'|'	=> \&_or,
	'&'	=> \&_and,
	'~'	=> \&_neg,
	'-'	=> \&_diff,
	'bool'	=> \&not_empty, # set is true if not empty
);

my %pm = qw/ [ -1 ( 1 ) -1 ] 1 /;
sub range {
	my ($cls, $a, $b, $spec) = @_;
	$spec =~ /^( \[ | \( )( \) | \] )$/x	or croak "bad spec $spec";

	$a = BNum->new($a, $pm{$1}, 0);
	$b = BNum->new($b, $pm{$2}, 1);
	normalize($a < $b ? [$a, $b] : [])
}

sub normalize {
	my @a = @{+shift};
	# remove invalid or duplicate borders, such as "[2, 1]" or "3) [3"
	# note that "(a" == "a]" and "a)" == "[a", but "a)" < "(a" and
	# "[a" < "a]"
	for (my $i = $#a; $i > 0; $i --) {
		splice @a, $i - 1, 2
			if $a[$i] <= $a[$i - 1]
	}
	bless \@a
}

sub not_empty { scalar @{ normalize shift } }

sub _str {
	my (@a, @s) = @{+shift}		or return '()';
	join " ∪ ", map { shift(@a).", ".shift(@a) } 0 .. $#a/2
}

sub _or {
	# we may have nested ranges now; let only outmost ones survive
	my $d = 0;
	normalize [
		map {	$_->[2] ? --$d ? () : ($_)
				: $d++ ? () : ($_) }
		sort{ $a <=> $b } @{+shift}, @{+shift}
	];
}

sub _neg {
	normalize [
		BNum->new('-inf', 1, 0),
		map($_->flip, @{+shift}),
		BNum->new('inf', -1, 1),
	]
}

sub _and {
	my $d = 0;
	normalize [
		map {	$_->[2] ? --$d ? ($_) : ()
				: $d++ ? ($_) : () }
		sort{ $a <=> $b } @{+shift}, @{+shift}
	];
}

sub _diff { shift() & ~shift() }

sub has {
	my ($a, $b) = @_;
	for (my $i = 0; $i < $#$a; $i += 2) {
		return 1 if $a->[$i] <= $b && $b <= $a->[$i + 1]
	}
	return 0
}

sub len {
	my ($a, $l) = shift;
	for (my $i = 0; $i < $#$a; $i += 2) {
		$l += $a->[$i+1][0] - $a->[$i][0]
	}
	return $l
}

package main;
use List::Util 'reduce';

sub rng { RealSet->range(@_) }
my @sets = (
	rng(0, 1, '(]') | rng(0, 2, '[)'),
	rng(0, 2, '[)') & rng(0, 2, '(]'),
	rng(0, 3, '[)') - rng(0, 1, '()'),
	rng(0, 3, '[)') - rng(0, 1, '[]'),
);

for my $i (0 .. $#sets) {
	print "Set $i = ", $sets[$i], ": ";
	for (0 .. 2) {
		print "has $_; " if $sets[$i]->has($_);
	}
	print "\n";
}

# optional task
print "\n####\n";
sub brev { # show only head and tail if string too long
	my $x = shift;
	return $x if length $x < 60;
	substr($x, 0, 30)." ... ".substr($x, -30, 30)
}

# "|sin(x)| > 1/2" means (n + 1/6) pi < x < (n + 5/6) pi
my $x = reduce { $a | $b }
	map(rng(sqrt($_ + 1./6), sqrt($_ + 5./6), '()'), 0 .. 101);
$x &= rng(0, 10, '()');

print "A\t", '= {x | 0 < x < 10 and |sin(π x²)| > 1/2 }',
	"\n\t= ", brev($x), "\n";

my $y = reduce { $a | $b }
	map { rng($_ + 1./6, $_ + 5./6, '()') } 0 .. 11;
$y &= rng(0, 10, '()');

print "B\t", '= {x | 0 < x < 10 and |sin(π x)| > 1/2 }',
	"\n\t= ", brev($y), "\n";

my $z = $x - $y;
print "A - B\t= ", brev($z), "\n\tlength = ", $z->len, "\n";
print $z ? "not empty\n" : "empty\n";
