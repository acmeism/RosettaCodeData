#!/usr/bin/perl

use utf8;
use strict;
binmode STDOUT, ":utf8";

my (@tgt, %names);
sub setprops {
	my %h = @_;
	my @p = keys %h;
	for my $p (@p) {
		my @v = @{ $h{$p} };
		@tgt = map(+{idx=>$_-1, map{ ($_, undef) } @p}, 1 .. @v)
			unless @tgt;
		$names{$_} = $p for @v;
	}
}

my $solve = sub {
	for my $i (@tgt) {
		printf("%12s", ucfirst($i->{$_} // "¿Qué?"))
				for reverse sort keys %$i;
		print "\n";
	}
	"there is only one"  # <--- change this to a false value to find all solutions (if any)
};

sub pair {
	my ($a, $b, @v) = @_;
	if ($a =~ /^(\d+)$/) {
		$tgt[$1]{ $names{$b} } = $b;
		return;
	}

	@v = (0) unless @v;
	my %allowed;
	$allowed{$_} = 1 for @v;

	my ($p1, $p2) = ($names{$a}, $names{$b});

	my $e = $solve;
	$solve = sub {		# <--- sorta like how TeX \let...\def macro
		my ($x, $y);

		($x) = grep { $_->{$p1} eq $a } @tgt;
		($y) = grep { $_->{$p2} eq $b } @tgt;

		$x and $y and
			return $allowed{ $x->{idx} - $y->{idx} } && $e->();

		my $try_stuff = sub {
			my ($this, $p, $v, $sign) = @_;
			for (@v) {
				my $i = $this->{idx} + $sign * $_;
				next unless $i >= 0 && $i < @tgt && !$tgt[$i]{$p};
				local $tgt[$i]{$p} = $v;
				$e->() and return 1;
			}
			return
		};

		$x and return $try_stuff->($x, $p2, $b, 1);
		$y and return $try_stuff->($y, $p1, $a, -1);

		for $x (@tgt) {
			next if $x->{$p1};
			local $x->{$p1} = $a;
			$try_stuff->($x, $p2, $b, 1) and return 1;
		}
	};
}

# ---- above should be generic for all similar puzzles ---- #

# ---- below: per puzzle setup ---- #
# property names and values
setprops (
	# Svensk n. a Swede, not a swede (kålrot).
	# AEnglisk (from middle Viking "Æŋløsåksen") n. a Brit.
	'Who'	=> [ qw(Deutsch Svensk Norske Danske AEnglisk) ],
	'Pet'	=> [ qw(birds dog horse zebra cats) ],
	'Drink'	=> [ qw(water tea milk beer coffee) ],
	'Smoke'	=> [ qw(dunhill blue_master prince blend pall_mall) ],
	'Color'	=> [ qw(red green yellow white blue) ]
);

# constraints
pair qw( AEnglisk red );
pair qw( Svensk dog );
pair qw( Danske tea );
pair qw( green white 1 );	# "to the left of" can mean either 1 or -1: ambiguous
pair qw( coffee green );
pair qw( pall_mall birds );
pair qw( yellow dunhill );
pair qw( 2 milk );
pair qw( 0 Norske );
pair qw( blend cats -1 1 );
pair qw( horse dunhill -1 1 );
pair qw( blue_master beer );	# Nicht das Deutsche Bier trinken? Huh.
pair qw( Deutsch prince );
pair qw( Norske blue -1 1 );
pair qw( water blend -1 1 );

$solve->();
