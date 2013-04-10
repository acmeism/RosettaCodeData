#!/usr/bin/perl
use warnings;
use strict;
use v5.10;

# Build a list of all possible solutions.  The regular expression weeds
# out numbers containing zeroes or repeated digits.  See how Perl
# automatically converts numbers to strings for us, just because we
# use them as if they were strings:
my @candidates = grep {not /0 | (\d) .* \1 /x} 1234 .. 9876;

# Repeatedly prompt for input until the user supplies a reasonable score.
# The regex validates the user's input and then returns two numbers,
# $+{BULLS} and $+{COWS}.

sub read_score($) {
    (my $guess) = @_;

    for (;;) {
        say "My guess: $guess   (from ", 0+@candidates, " possibilities)";
        if (<> =~ / ^ \h* (?<BULLS> \d) \h* (?<COWS> \d) \h* $ /x and
            $+{BULLS} + $+{COWS} <= 4) {
                return ($+{BULLS}, $+{COWS});
        }

        say "Please specify the number of bulls and the number of cows";
    }
}

sub score_correct($$$$) {
    my ($a, $b, $bulls, $cows) = @_;

    # Count the positions at which the digits match:
    my $exact = () = grep {substr($a, $_, 1) eq substr($b, $_, 1)} 0 .. 3;

    # Cross-match all digits in $a against all digits in $b, using a regex
    # (specifically, a character class) instead of an explicit loop:
    my $loose = () = $a =~ /[$b]/g;

    return $bulls == $exact && $cows == $loose - $exact;
}

do {
    # Pick a number, display it, get the score, and discard candidates
    # that don't match the score:
    my $guess = @candidates[rand @candidates];
    my ($bulls, $cows) = read_score $guess;
    @candidates = grep {score_correct $_, $guess, $bulls, $cows} @candidates;
} while (@candidates > 1);

say(@candidates?
    "Your secret number is @candidates":
    "I think you made a mistake with your scoring");
