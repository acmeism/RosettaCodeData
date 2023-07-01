use strict;
use warnings qw(FATAL all);
use feature 'bitwise';

my $n = shift(@ARGV) || 4;
if( $n < 2 or $n > 26 ) {
	die "You can't play a size $n game\n";
}

my $n2 = $n*$n;

my (@rows, @cols);
for my $i ( 0 .. $n-1 ) {
	my $row = my $col = "\x00" x $n2;
	vec($row, $i * $n + $_, 8) ^= 1 for 0 .. $n-1;
	vec($col, $i + $_ * $n, 8) ^= 1 for 0 .. $n-1;
	push @rows, $row;
	push @cols, $col;
}

my $goal = "0" x $n2;
int(rand(2)) or (vec($goal, $_, 8) ^= 1) for 0 .. $n2-1;
my $start = $goal;
{
	for(@rows, @cols) {
		$start ^.= $_ if int rand 2;
	}
	redo if $start eq $goal;
}

my @letters = ('a'..'z')[0..$n-1];
sub to_strings {
	my $board = shift;
	my @result = join(" ", "  ", @letters);
	for( 0 .. $n-1 ) {
		my $res = sprintf("%2d ",$_+1);
		$res .= join " ", split //, substr $board, $_*$n, $n;
		push @result, $res;
	}
	\@result;
}

my $fmt;
my ($stext, $etext) = ("Starting board", "Ending board");
my $re = join "|", reverse 1 .. $n, @letters;
my $moves_so_far = 0;
while( 1 ) {
	my ($from, $to) = (to_strings($start), to_strings($goal));
	unless( $fmt ) {
		my $len = length $from->[0];
		$len = length($stext) if $len < length $stext;
		$fmt = join($len, "%", "s%", "s\n");
	}
	printf $fmt, $stext, $etext;
	printf $fmt, $from->[$_], $to->[$_] for 0 .. $n;
	last if $start eq $goal;
	INPUT_LOOP: {
		printf "Move #%s: Type one or more row numbers and/or column letters: ",
			$moves_so_far+1;
		my $input = <>;
		die unless defined $input;
		my $did_one;
		for( $input =~ /($re)/gi ) {
			$did_one = 1;
			if( /\d/ ) {
				$start ^.= $rows[$_-1];
			} else {
				$_ = ord(lc) - ord('a');
				$start ^.= $cols[$_];
			}
			++$moves_so_far;
		}
		redo INPUT_LOOP unless $did_one;
	}
}
print "You won after $moves_so_far moves.\n";
