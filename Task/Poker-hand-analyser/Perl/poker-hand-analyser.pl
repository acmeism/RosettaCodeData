use strict;
use warnings;
use utf8;
use feature 'say';
use open qw<:encoding(utf-8) :std>;

package Hand {
    sub describe {
        my $str = pop;
        my $hand = init($str);
        return "$str: INVALID" if !$hand;
        return analyze($hand);
    }

    sub init {
        (my $str = lc shift) =~ tr/234567891jqka♥♦♣♠//cd;
        return if $str !~ m/\A (?: [234567891jqka] [♥♦♣♠] ){5} \z/x;
        for (my ($i, $cnt) = (0, 0); $i < 10; $i += 2, $cnt = 0) {
            my $try = substr $str, $i, 2;
            ++$cnt while $str =~ m/$try/g;
            return if $cnt > 1;
        }
        my $suits = $str =~ tr/234567891jqka//dr;
        my $ranks = $str =~ tr/♥♦♣♠//dr;
        return {
            hand  => $str,
            suits => $suits,
            ranks => $ranks,
        };
    }

    sub analyze {
        my $hand = shift;
        my @ranks = split //, $hand->{ranks};
        my %cards;
        for (@ranks) {
            $_ = 10, next if $_ eq '1';
            $_ = 11, next if $_ eq 'j';
            $_ = 12, next if $_ eq 'q';
            $_ = 13, next if $_ eq 'k';
            $_ = 14, next if $_ eq 'a';
        } continue {
            ++$cards{ $_ };
        }
        my $kicker = 0;
        my (@pairs, $set, $quads, $straight, $flush);

        while (my ($card, $count) = each %cards) {
            if ($count == 1) {
                $kicker = $card if $kicker < $card;
            }
            elsif ($count == 2) {
                push @pairs, $card;
            }
            elsif ($count == 3) {
                $set = $card;
            }
            elsif ($count == 4) {
                $quads = $card;
            }
            else {
                die "Five of a kind? Cheater!\n";
            }
        }
        $flush    = 1 if $hand->{suits} =~ m/\A (.) \1 {4}/x;
        $straight = check_straight(@ranks);
        return get_high($kicker, \@pairs, $set, $quads, $straight, $flush,);
    }

    sub check_straight {
        my $sequence = join ' ', sort { $a <=> $b } @_;
        return 1       if index('2 3 4 5 6 7 8 9 10 11 12 13 14', $sequence) != -1;
        return 'wheel' if index('2 3 4 5 14 6 7 8 9 10 11 12 13', $sequence) ==  0;
        return undef;
    }

    sub get_high {
        my ($kicker, $pairs, $set, $quads, $straight, $flush) = @_;
        $kicker = to_s($kicker, 's');
        return 'straight-flush: Royal Flush!'
            if $straight && $flush && $kicker eq 'Ace' && $straight ne 'wheel';
        return "straight-flush: Steel Wheel!"
            if $straight && $flush && $straight eq 'wheel';
        return "straight-flush: $kicker high"
            if $straight && $flush;
        return 'four-of-a-kind: '. to_s($quads, 'p')
            if $quads;
        return 'full-house: '. to_s($set, 'p') .' full of '. to_s($pairs->[0], 'p')
            if $set && @$pairs;
        return "flush: $kicker high"
            if $flush;
        return 'straight: Wheel!'
            if $straight && $straight eq 'wheel';
        return "straight: $kicker high"
            if $straight;
        return 'three-of-a-kind: '. to_s($set, 'p')
            if $set;
        return 'two-pairs: '. to_s($pairs->[0], 'p') .' and '. to_s($pairs->[1], 'p')
            if @$pairs == 2;
        return 'one-pair: '. to_s($pairs->[0], 'p')
            if @$pairs == 1;
        return "high-card: $kicker";
    }

    my %to_str = (
         2 => 'Two',    3 => 'Three', 4 => 'Four',  5 => 'Five', 6 => 'Six',
         7 => 'Seven',  8 => 'Eight', 9 => 'Nine', 10 => 'Ten', 11 => 'Jack',
        12 => 'Queen', 13 => 'King', 14 => 'Ace',
    );
    my %to_str_diffs = (2 => 'Deuces', 6 => 'Sixes',);

    sub to_s {
        my ($num, $verb) = @_;
        # verb is 'singular' or 'plural' (or 's' or 'p')
        if ($verb =~ m/\A p/xi) {
            return $to_str_diffs{ $num } if $to_str_diffs{ $num };
            return $to_str{ $num } .'s';
        }
        return $to_str{ $num };
    }
}

my @cards = (
    '10♥ j♥  q♥ k♥ a♥',
    '2♥  3♥  4♥ 5♥ a♥',
    '2♥  2♣  2♦ 3♣ 2♠',
    '10♥ K♥  K♦ K♣ 10♦',
    'q♣  10♣ 7♣ 6♣ 3♣',
    '5♣  10♣ 7♣ 6♣ 4♣',
    '9♥  10♥ q♥ k♥ j♣',
    'a♥  a♣  3♣ 4♣ 5♦',
    '2♥  2♦  2♣ k♣ q♦',
    '6♥  7♥  6♦ j♣ j♦',
    '2♥  6♥  2♦ 3♣ 3♦',
    '7♥  7♠  k♠ 3♦ 10♠',
    '4♥  4♠  k♠ 2♦ 10♠',
    '2♥  5♥  j♦ 8♣ 9♠',
    '2♥  5♥  7♦ 8♣ 9♠',
    'a♥  a♥  3♣ 4♣ 5♦', # INVALID: duplicate aces
);

say Hand::describe($_) for @cards;
