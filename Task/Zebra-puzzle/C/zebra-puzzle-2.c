#!/usr/bin/perl

use utf8;
no strict;

my (%props, %name, @pre, @conds, @works, $find_all_solutions);

sub do_consts {
	local $";
	for my $p (keys %props) {
		my @s = @{ $props{$p} };

		$" = ", ";
		print "enum { ${p}_none = 0, @s };\n";

		$" = '", "';
		print "const char *string_$p [] = { \"###\", \"@s\" };\n\n";
	}
	print "#define FIND_BY(p)	\\
int find_by_##p(int v) {		\\
int i;					\\
for (i = 0; i < N_ITEMS; i++)		\\
	if (house[i].p == v) return i;	\\
return -1; }\n";

	print "FIND_BY($_)" for (keys %props);

	local $" = ", ";
	my @k = keys %props;

	my $sl = 0;
	for (keys %name) {
		if (length > $sl) { $sl = length }
	}

	my $fmt = ("%".($sl + 1)."s ") x @k;
	my @arg = map { "string_$_"."[house[i].$_]" } @k;
	print << "SNIPPET";
int work0(void) {
	int i;
	for (i = 0; i < N_ITEMS; i++)
		printf("%d $fmt\\n", i, @arg);
	puts(\"\");
	return 1;
}
SNIPPET

}

sub setprops {
	%props = @_;
	my $l = 0;
	my @k = keys %props;
	for my $p (@k) {
		my @s = @{ $props{$p} };

		if ($l && $l != @s) {
			die "bad length @s";
		}
		$l = @s;
		$name{$_} = $p for @s;
	}
	local $" = ", ";
	print "#include <stdio.h>
#define N_ITEMS $l
struct item_t { int @k; } house[N_ITEMS] = {{0}};\n";
}

sub pair {NB.   h =.~.&> compose&.>~/y,<h

	my ($c1, $c2, $diff) = @_;
	$diff //= [0];
	$diff = [$diff] unless ref $diff;

	push @conds, [$c1, $c2, $diff];
}

sub make_conditions {
	my $idx = 0;
	my $return1 = $find_all_solutions ? "" : "return 1";
	print "
#define TRY(a, b, c, d, p, n)		\\
if ((b = a d) >= 0 && b < N_ITEMS) {	\\
	if (!house[b].p) {		\\
		house[b].p = c;		\\
		if (n()) $return1;	\\
		house[b].p = 0;		\\
	}}
";

	while (@conds) {
		my ($c1, $c2, $diff) = @{ pop @conds };
		my $p2 = $name{$c2} or die "bad prop $c2";

		if ($c1 =~ /^\d+$/) {
			push @pre, "house[$c1].$p2 = $c2;";
			next;
		}

		my $p1 = $name{$c1} or die "bad prop $c1";
		my $next = "work$idx";
		my $this = "work".++$idx;

		print "
/* condition pair($c1, $c2, [@$diff]) */
int $this(void) {
int a = find_by_$p1($c1);
int b = find_by_$p2($c2);
if (a != -1 && b != -1) {
switch(b - a) {
";
		print "case $_: " for @$diff;
		print "return $next(); default: return 0; }\n } if (a != -1) {";
		print "TRY(a, b, $c2, +($_), $p2, $next);" for @$diff;
		print " return 0; } if (b != -1) {";
		print "TRY(b, a, $c1, -($_), $p1, $next);" for @$diff;
		print "
return 0; }
/* neither condition is set; try all possibles */
for (a = 0; a < N_ITEMS; a++) {
if (house[a].$p1) continue;
house[a].$p1 = $c1;
";

		print "TRY(a, b, $c2, +($_), $p2, $next);" for @$diff;
		print " house[a].$p1 = 0; } return 0; }";
	}

	print "int main() { @pre return !work$idx(); }";
}

sub make_c {
	do_consts;
	make_conditions;
}

# ---- above should be generic for all similar puzzles ---- #

# ---- below: per puzzle setup ---- #
# property names and values
setprops (
	'nationality'	# Svensk n. a Swede, not a swede (kålrot).
			# AEnglisk (from middle Viking "Æŋløsåksen") n. a Brit.
		=> [ qw(Deutsch Svensk Norske Danske AEnglisk) ],
	'pet'	=> [ qw(birds dog horse zebra cats) ],
	'drink'	=> [ qw(water tea milk beer coffee) ],
	'smoke'	=> [ qw(dunhill blue_master prince blend pall_mall) ],
	'color'	=> [ qw(red green yellow white blue) ]
);

# constraints
pair(AEnglisk, red);
pair(Svensk, dog);
pair(Danske, tea);
pair(green, white, 1);	# "to the left of" can mean either 1 or -1: ambiguous
pair(coffee, green);
pair(pall_mall, birds);
pair(yellow, dunhill);
pair(2, milk);
pair(0, Norske);
pair(blend, cats, [-1, 1]);
pair(horse, dunhill, [-1, 1]);
pair(blue_master, beer);	# Nicht das Deutsche Bier trinken? Huh.
pair(Deutsch, prince);
pair(Norske, blue, [-1, 1]);
pair(water, blend, [-1, 1]);

# "zebra lives *somewhere* relative to the Brit".  It has no effect on
# the logic.  It's here just to make sure the code will insert a zebra
# somewhere in the table (after all other conditions are met) so the
# final print-out shows it. (the C code can be better structured, but
# meh, I ain't reading it, so who cares).
pair(zebra, AEnglisk, [ -4 .. 4 ]);

# write C code.  If it's ugly to you: I didn't write; Perl did.
make_c;
