#!/usr/bin/perl -w
use strict;
use warnings;

sub sexpr
{
	my @stack = ([]);
	local $_ = $_[0];

	while (m{
		\G    # start match right at the end of the previous one
		\s*+  # skip whitespaces
		# now try to match any of possible tokens in THIS order:
		(?<lparen>\() |
		(?<rparen>\)) |
		(?<FLOAT>[0-9]*+\.[0-9]*+) |
		(?<INT>[0-9]++) |
		(?:"(?<STRING>([^\"\\]|\\.)*+)") |
		(?<IDENTIFIER>[^\s()]++)
		# Flags:
		#  g = match the same string repeatedly
		#  m = ^ and $ match at \n
		#  s = dot and \s matches \n
		#  x = allow comments within regex
		}gmsx)
	{
		die "match error" if 0+(keys %+) != 1;

		my $token = (keys %+)[0];
		my $val = $+{$token};

		if ($token eq 'lparen') {
			my $a = [];
			push @{$stack[$#stack]}, $a;
			push @stack, $a;
		} elsif ($token eq 'rparen') {
			pop @stack;
		} else {
			push @{$stack[$#stack]}, bless \$val, $token;
		}
	}
	return $stack[0]->[0];
}

sub quote
{ (local $_ = $_[0]) =~ /[\s\"\(\)]/s ? do{s/\"/\\\"/gs; qq{"$_"}} : $_; }

sub sexpr2txt
{
	qq{(@{[ map {
		ref($_) eq '' ? quote($_) :
		ref($_) eq 'STRING' ? quote($$_) :
		ref($_) eq 'ARRAY' ? sexpr2txt($_) : $$_
	} @{$_[0]} ]})}
}
