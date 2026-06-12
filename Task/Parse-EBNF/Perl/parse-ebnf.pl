#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

package EBNFParser;
use Data::Dumper;

sub new {
    my $class = shift;
    my $self = {
        src => '',
        ch => '',
        sdx => 0,
        token => undef,
        err => 0,
        idents => [],
        ididx => [],
        productions => [],
        extras => [],
        results => ["pass", "fail"]
    };
    bless $self, $class;
    return $self;
}

sub btoi {
    my ($self, $b) = @_;
    return $b ? 1 : 0;
}

sub invalid {
    my ($self, $msg) = @_;
    $self->{err} = 1;
    print "$msg\n";
    $self->{sdx} = length($self->{src}); # set to eof
    return -1;
}

sub skip_spaces {
    my $self = shift;
    while ($self->{sdx} < length($self->{src})) {
        $self->{ch} = substr($self->{src}, $self->{sdx}, 1);
        last unless $self->{ch} =~ /[ \t\r\n]/;
        $self->{sdx}++;
    }
}

sub get_token {
    my $self = shift;
    # Yields a single character token, one of {}()[]|=.;
    # or ["terminal", string] or ["ident", string] or -1.
    $self->skip_spaces();
    if ($self->{sdx} >= length($self->{src})) {
        $self->{token} = -1;
        return;
    }
    my $tokstart = $self->{sdx};
    if ($self->{ch} =~ /[{}()\[\]|=.;]/) {
        $self->{sdx}++;
        $self->{token} = $self->{ch};
    } elsif ($self->{ch} eq '"' || $self->{ch} eq "'") {
        my $closech = $self->{ch};
        my $tokend = $tokstart + 1;
        while ($tokend < length($self->{src}) && substr($self->{src}, $tokend, 1) ne $closech) {
            $tokend++;
        }
        if ($tokend >= length($self->{src})) {
            $self->{token} = $self->invalid("no closing quote");
        } else {
            $self->{sdx} = $tokend + 1;
            $self->{token} = ["terminal", substr($self->{src}, $tokstart + 1, $tokend - $tokstart - 1)];
        }
    } elsif ($self->{ch} =~ /[a-z]/) {
        # To simplify things for the purposes of this task,
        # identifiers are strictly a-z only, not A-Z or 1-9.
        while ($self->{sdx} < length($self->{src}) && substr($self->{src}, $self->{sdx}, 1) =~ /[a-z]/) {
            $self->{sdx}++;
            if ($self->{sdx} < length($self->{src})) {
                $self->{ch} = substr($self->{src}, $self->{sdx}, 1);
            }
        }
        $self->{token} = ["ident", substr($self->{src}, $tokstart, $self->{sdx} - $tokstart)];
    } else {
        $self->{token} = $self->invalid("invalid ebnf");
    }
}

sub match_token {
    my ($self, $expected_ch) = @_;
    if ($self->{token} ne $expected_ch) {
        $self->{token} = $self->invalid(sprintf("invalid ebnf (%s expected)", $expected_ch));
    } else {
        $self->get_token();
    }
}

sub add_ident {
    my ($self, $ident) = @_;
    my $k = -1;
    for my $i (0..$#{$self->{idents}}) {
        if ($self->{idents}->[$i] eq $ident) {
            $k = $i;
            last;
        }
    }
    if ($k == -1) {
        push @{$self->{idents}}, $ident;
        $k = $#{$self->{idents}};
        push @{$self->{ididx}}, -1;
    }
    return $k;
}

sub factor {
    my $self = shift;
    my $res;
    if (ref($self->{token}) eq 'ARRAY') {
        my $t = $self->{token};
        if ($t->[0] eq "ident") {
            my $idx = $self->add_ident($t->[1]);
            push @$t, $idx;
            $self->{token} = $t;
        }
        $res = $self->{token};
        $self->get_token();
    } elsif ($self->{token} eq '[') {
        $self->get_token();
        $res = ["optional", $self->expression()];
        $self->match_token(']');
    } elsif ($self->{token} eq '(') {
        $self->get_token();
        $res = $self->expression();
        $self->match_token(')');
    } elsif ($self->{token} eq '{') {
        $self->get_token();
        $res = ["repeat", $self->expression()];
        $self->match_token('}');
    } else {
        die "invalid token in factor() function";
    }
    if (ref($res) eq 'ARRAY' && @$res == 1) {
        return $res->[0];
    }
    return $res;
}

sub term {
    my $self = shift;
    my $res = [$self->factor()];
    my @tokens = (-1, '|', '.', ';', ')', ']', '}');

    while (1) {
        my $found = 0;
        for my $t (@tokens) {
            if (defined($self->{token}) && $t eq $self->{token}) {
                $found = 1;
                last;
            }
        }
        last if $found;
        push @$res, $self->factor();
    }

    if (@$res == 1) {
        return $res->[0];
    }
    return $res;
}

sub expression {
    my $self = shift;
    my $res = [$self->term()];
    if (defined($self->{token}) && $self->{token} eq '|') {
        $res = ["or", $res->[0]];
        while (defined($self->{token}) && $self->{token} eq '|') {
            $self->get_token();
            push @$res, $self->term();
        }
    }
    if (@$res == 1) {
        return $res->[0];
    }
    return $res;
}

sub production {
    my $self = shift;
    # Returns a token or -1; the real result is left in 'productions' etc,
    $self->get_token();
    if (defined($self->{token}) && $self->{token} ne '}') {
        if ($self->{token} eq -1) {
            return $self->invalid("invalid ebnf (missing closing })");
        }
        if (ref($self->{token}) ne 'ARRAY') {
            return -1;
        }
        my $t = $self->{token};
        if ($t->[0] ne "ident") {
            return -1;
        }
        my $ident = $t->[1];
        my $idx = $self->add_ident($ident);
        $self->get_token();
        $self->match_token('=');
        if ($self->{token} eq -1) {
            return -1;
        }
        push @{$self->{productions}}, [$ident, $idx, $self->expression()];
        $self->{ididx}->[$idx] = $#{$self->{productions}};
    }
    return $self->{token};
}

sub parse {
    my ($self, $ebnf) = @_;
    # Returns +1 if ok, -1 if bad.
    printf "parse:\n%s ===>\n", $ebnf;
    $self->{err} = 0;
    $self->{src} = $ebnf;
    $self->{sdx} = 0;
    $self->{idents} = [];
    $self->{ididx} = [];
    $self->{productions} = [];
    $self->{extras} = [];

    $self->get_token();
    if (ref($self->{token}) eq 'ARRAY') {
        my $t = $self->{token};
        $t->[0] = "title";
        push @{$self->{extras}}, $self->{token};
        $self->get_token();
    }
    if (!defined($self->{token}) || $self->{token} ne '{') {
        return $self->invalid("invalid ebnf (missing opening {)");
    }

    while (1) {
        my $token_result = $self->production();
        last if (defined($token_result) && ($token_result eq '}' || $token_result eq -1));
    }

    $self->get_token();
    if (ref($self->{token}) eq 'ARRAY') {
        my $t = $self->{token};
        $t->[0] = "comment";
        push @{$self->{extras}}, $self->{token};
        $self->get_token();
    }
    if (defined($self->{token}) && $self->{token} ne -1) {
        return $self->invalid("invalid ebnf (missing eof?)");
    }
    if ($self->{err}) {
        return -1;
    }

    my $k = -1;
    for my $i (0..$#{$self->{ididx}}) {
        if ($self->{ididx}->[$i] == -1) {
            $k = $i;
            last;
        }
    }
    if ($k != -1) {
        return $self->invalid(sprintf("invalid ebnf (undefined:%s)", $self->{idents}->[$k]));
    }

    $self->pprint($self->{productions}, "productions");
    $self->pprint($self->{idents}, "idents");
    $self->pprint($self->{ididx}, "ididx");
    $self->pprint($self->{extras}, "extras");
    return 1;
}

# Adjusts Perl's normal printing to look more like Phix output.
sub pprint {
    my ($self, $ob, $header) = @_;
    printf "\n%s:\n", $header;
    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Indent = 0;
    my $pp = Dumper($ob);
    $pp =~ s/\[/\{/g;
    $pp =~ s/\]/\}/g;
    $pp =~ s/,/, /g;
    chomp $pp;
    print "$pp\n";
}

# The rules that applies() has to deal with are:
# [factors] - if rule[0] is not string,
# just apply one after the other recursively.
# ["terminal", "a1"]       -- literal constants
# ["or", <e1>, <e2>, ...]  -- (any) one of n
# ["repeat", <e1>]         -- as per "{}" in ebnf
# ["optional", <e1>]       -- as per "[]" in ebnf
# ["ident", <name>, idx]   -- apply the sub-rule

sub applies {
    my ($self, $rule) = @_;
    my $was_sdx = $self->{sdx}; # in case of failure
    my $r1 = ref($rule) eq 'ARRAY' ? $rule->[0] : $rule;

    if (ref($rule) eq 'ARRAY' && ref($r1) ne '') {
        for my $i (0..$#{$rule}) {
            if (!$self->applies($rule->[$i])) {
                $self->{sdx} = $was_sdx;
                return 0;
            }
        }
    } elsif (ref($rule) eq 'ARRAY' && $r1 eq "terminal") {
        $self->skip_spaces();
        my $r2 = $rule->[1];
        for my $i (0..length($r2)-1) {
            if ($self->{sdx} >= length($self->{src}) ||
                substr($self->{src}, $self->{sdx}, 1) ne substr($r2, $i, 1)) {
                $self->{sdx} = $was_sdx;
                return 0;
            }
            $self->{sdx}++;
        }
    } elsif (ref($rule) eq 'ARRAY' && $r1 eq "or") {
        for my $i (1..$#{$rule}) {
            if ($self->applies($rule->[$i])) {
                return 1;
            }
        }
        $self->{sdx} = $was_sdx;
        return 0;
    } elsif (ref($rule) eq 'ARRAY' && $r1 eq "repeat") {
        while ($self->applies($rule->[1])) {
            # continue repeating
        }
    } elsif (ref($rule) eq 'ARRAY' && $r1 eq "optional") {
        $self->applies($rule->[1]);
    } elsif (ref($rule) eq 'ARRAY' && $r1 eq "ident") {
        my $i = $rule->[2];
        my $ii = $self->{ididx}->[$i];
        if (!$self->applies($self->{productions}->[$ii]->[2])) {
            $self->{sdx} = $was_sdx;
            return 0;
        }
    } else {
        die "invalid rule in applies() function";
    }
    return 1;
}

sub check_valid {
    my ($self, $test) = @_;
    $self->{src} = $test;
    $self->{sdx} = 0;
    my $res = $self->applies($self->{productions}->[0]->[2]);
    $self->skip_spaces();
    if ($self->{sdx} < length($self->{src})) {
        $res = 0;
    }
    printf "\"%s\", %s\n", $test, $self->{results}->[1 - $self->btoi($res)];
}

# Main execution
package main;

my $parser = EBNFParser->new();

my @ebnfs = (
    "\"a\" {\n" .
    "    a = \"a1\" ( \"a2\" | \"a3\" ) { \"a4\" } [ \"a5\" ] \"a6\" ;\n" .
    "} \"z\" ",

    "{\n" .
    "    expr = term { plus term } .\n" .
    "    term = factor { times factor } .\n" .
    "    factor = number | '(' expr ')' .\n" .
    " \n" .
    "    plus = \"+\" | \"-\" .\n" .
    "    times = \"*\" | \"/\" .\n" .
    " \n" .
    "    number = digit { digit } .\n" .
    "    digit = \"0\" | \"1\" | \"2\" | \"3\" | \"4\" | \"5\" | \"6\" | \"7\" | \"8\" | \"9\" .\n" .
    "}",

    "a = \"1\"",
    "{ a = \"1\" ;",
    "{ hello world = \"1\"; }",
    "{ foo = bar . }"
);

my @tests = (
    [
        "a1a3a4a4a5a6",
        "a1 a2a6",
        "a1 a3 a4 a6",
        "a1 a4 a5 a6",
        "a1 a2 a4 a5 a5 a6",
        "a1 a2 a4 a5 a6 a7",
        "your ad here"
    ],
    [
        "2",
        "2*3 + 4/23 - 7",
        "(3 + 4) * 6-2+(4*(4))",
        "-2",
        "3 +",
        "(4 + 3"
    ]
);

for my $i (0..$#ebnfs) {
    if ($parser->parse($ebnfs[$i]) == 1) {
        print "\ntests:\n";
        if ($i < @tests) {
            for my $test (@{$tests[$i]}) {
                $parser->check_valid($test);
            }
        }
    }
    print "\n";
}
