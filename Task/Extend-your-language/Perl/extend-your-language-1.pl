#!/usr/bin/perl
use warnings;
use strict;
use v5.10;

=for starters

Syntax:

    if2 condition1, condition2, then2 {
        # both conditions are true
    }
    else1 {
        # only condition1 is true
    }
    else2 {
        # only condition2 is true
    }
    orelse {
        # neither condition is true
    };

Any (but not all) of the `then' and `else' clauses can be omitted, and else1
and else2 can be specified in either order.

This extension is imperfect in several ways:
* A normal if-statement uses round brackets, but this syntax forbids them.
* Perl doesn't have a `then' keyword; if it did, it probably wouldn't be
  preceded by a comma.
* Unless it's the last thing in a block, the whole structure must be followed
  by a semicolon.
* Error messages appear at runtime, not compile time, and they don't show the
  line where the user's syntax error occurred.

We could solve most of these problems with a source filter, but those are
dangerous.  Can anyone else do better?  Feel free to improve or replace.

=cut

# All the new `keywords' are in fact functions.  Most of them return lists
# of four closures, one of which is then executed by if2.  Here are indexes into
# these lists:

use constant {
    IdxThen     => 0,
    IdxElse1    => 1,
    IdxElse2    => 2,
    IdxOrElse   => 3
};

# Most of the magic is in the (&) prototype, which lets a function accept a
# closure marked by nothing except braces.

sub orelse(&) {
    my $clause = shift;
    return undef, undef, undef, $clause;
}

sub else2(&@) {
    my $clause = shift;
    die "Can't have two `else2' clauses"
        if defined $_[IdxElse2];

    return (undef, $_[IdxElse1], $clause, $_[IdxOrElse]);
}

sub else1(&@) {
    my $clause = shift;
    die "Can't have two `else1' clauses"
        if defined $_[IdxElse1];

    return (undef, $clause, $_[IdxElse2], $_[IdxOrElse]);
}

sub then2(&@) {
    die "Can't have two `then2' clauses"
        if defined $_[1+IdxThen];

    splice @_, 1+IdxThen, 1;
    return @_;
}

# Here, we collect the two conditions and four closures (some of which will be
# undefined if some clauses are missing).  We work out which of the four
# clauses (closures) to call, and call it if it exists.

use constant {
    # Defining True and False is almost always bad practice, but here we
    # have a valid reason.
    True  => (0 == 0),
    False => (0 == 1)
};

sub if2($$@) {
    my $cond1 = !!shift;    # Convert to Boolean to guarantee matching
    my $cond2 = !!shift;    # against either True or False

    die "if2 must be followed by then2, else1, else2, &/or orelse"
        if @_ != 4
        or grep {defined and ref $_ ne 'CODE'} @_;

    my $index;
    if (!$cond1 && !$cond2) {$index = IdxOrElse}
    if (!$cond1 &&  $cond2) {$index = IdxElse2 }
    if ( $cond1 && !$cond2) {$index = IdxElse1 }
    if ( $cond1 &&  $cond2) {$index = IdxThen  }

    my $closure = $_[$index];
    &$closure   if defined $closure;
}

# This is test code.  You can play with it by deleting up to three of the
# four clauses.

sub test_bits($) {
    (my $n) = @_;

    print "Testing $n: ";

    if2 $n & 1, $n & 2, then2 {
        say "Both bits 0 and 1 are set";
    }
    else1 {
        say "Only bit 0 is set";
    }
    else2 {
        say "Only bit 1 is set";
    }
    orelse {
        say "Neither bit is set";
    }
}

test_bits $_   for 0 .. 7;
