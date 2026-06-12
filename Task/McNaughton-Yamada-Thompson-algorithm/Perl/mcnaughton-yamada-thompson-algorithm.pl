#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(any);

# State class equivalent
package State {
    sub new {
        my ($class, $label) = @_;
        my $self = {
            label => defined($label) ? $label : "\0",
            edge1 => undef,
            edge2 => undef
        };
        bless $self, $class;
        return $self;
    }
}

# NFA class equivalent
package NFA {
    sub new {
        my ($class, $initial, $accept) = @_;
        my $self = {
            initial => $initial,
            accept => $accept
        };
        bless $self, $class;
        return $self;
    }
}

package main;

sub main {
    my @infixes = ("a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c");
    my @strings = ("", "abc", "abbc", "abcc", "abad", "abbbc");

    for my $infix (@infixes) {
        for my $string (@strings) {
            my $result = match_regex($string, $infix);
            print(($result ? "True " : "False ") . "$infix $string\n");
        }
        print "\n";
    }
}

# Match the given string against the given infix regex
sub match_regex {
    my ($text, $infix) = @_;
    my $postfix = shunt($infix);
    # Uncomment the next line to see the postfix expression
    # print "Postfix: $postfix\n";

    my $nfa = compile_regex($postfix);

    my $current = followes($nfa->{initial});
    my $next_states = [];

    for my $ch (split //, $text) {
        for my $state (@$current) {
            if ($state->{label} eq $ch) {
                my $follow = followes($state->{edge1});
                push @$next_states, @$follow;
            }
        }
        $current = [@$next_states];
        $next_states = [];
    }

    return _contains_state($current, $nfa->{accept});
}

# Compile the given postfix regex into an NFA
sub compile_regex {
    my ($postfix) = @_;
    my @nfa_stack = ();

    for my $ch (split //, $postfix) {
        if ($ch eq '*') {
            my $nfa1 = pop @nfa_stack;
            my $initial = State->new();
            my $accept = State->new();
            $initial->{edge1} = $nfa1->{initial};
            $initial->{edge2} = $accept;
            $nfa1->{accept}->{edge1} = $nfa1->{initial};
            $nfa1->{accept}->{edge2} = $accept;
            push @nfa_stack, NFA->new($initial, $accept);
        }
        elsif ($ch eq '.') {
            my $nfa2 = pop @nfa_stack;
            my $nfa1 = pop @nfa_stack;
            $nfa1->{accept}->{edge1} = $nfa2->{initial};
            push @nfa_stack, NFA->new($nfa1->{initial}, $nfa2->{accept});
        }
        elsif ($ch eq '|') {
            my $nfa2 = pop @nfa_stack;
            my $nfa1 = pop @nfa_stack;
            my $initial = State->new();
            my $accept = State->new();
            $initial->{edge1} = $nfa1->{initial};
            $initial->{edge2} = $nfa2->{initial};
            $nfa1->{accept}->{edge1} = $accept;
            $nfa2->{accept}->{edge1} = $accept;
            push @nfa_stack, NFA->new($initial, $accept);
        }
        elsif ($ch eq '+') {
            my $nfa1 = pop @nfa_stack;
            my $initial = State->new();
            my $accept = State->new();
            $initial->{edge1} = $nfa1->{initial};
            $nfa1->{accept}->{edge1} = $nfa1->{initial};
            $nfa1->{accept}->{edge2} = $accept;
            push @nfa_stack, NFA->new($initial, $accept);
        }
        elsif ($ch eq '?') {
            my $nfa1 = pop @nfa_stack;
            my $initial = State->new();
            my $accept = State->new();
            $initial->{edge1} = $nfa1->{initial};
            $initial->{edge2} = $accept;
            $nfa1->{accept}->{edge1} = $accept;
            push @nfa_stack, NFA->new($initial, $accept);
        }
        else { # Literal character
            my $initial = State->new($ch);
            my $accept = State->new();
            $initial->{edge1} = $accept;
            push @nfa_stack, NFA->new($initial, $accept);
        }
    }

    return $nfa_stack[-1];
}

# Compute the epsilon closure of the given state
sub followes {
    my ($state) = @_;
    my @states = ();
    my @stack = ($state);

    while (@stack) {
        my $current = pop @stack;
        if (!_contains_state(\@states, $current)) {
            push @states, $current;
            if ($current->{label} eq "\0") { # Epsilon transition
                if (defined $current->{edge1}) {
                    push @stack, $current->{edge1};
                }
                if (defined $current->{edge2}) {
                    push @stack, $current->{edge2};
                }
            }
        }
    }

    return \@states;
}

# Helper function to check if a state array contains a specific state
sub _contains_state {
    my ($states, $target) = @_;
    for my $state (@$states) {
        return 1 if $state == $target;  # Reference equality
    }
    return 0;
}

# Convert the given infix regex to postfix regex using the Shunting Yard algorithm
sub shunt {
    my ($infix) = @_;
    my %specials = (
        '*' => 60,
        '+' => 55,
        '?' => 50,
        '.' => 40,
        '|' => 20
    );

    my @stack = ();
    my $postfix = "";

    for my $ch (split //, $infix) {
        if ($ch eq '(') {
            push @stack, $ch;
        }
        elsif ($ch eq ')') {
            while (@stack && $stack[-1] ne '(') {
                $postfix .= pop @stack;
            }
            if (@stack) {
                pop @stack; # Remove '('
            }
        }
        elsif (exists $specials{$ch}) {
            while (@stack && exists $specials{$stack[-1]} &&
                   $specials{$ch} <= $specials{$stack[-1]}) {
                $postfix .= pop @stack;
            }
            push @stack, $ch;
        }
        else {
            $postfix .= $ch;
        }
    }

    while (@stack) {
        $postfix .= pop @stack;
    }

    return $postfix;
}

# Run the main function
main();
