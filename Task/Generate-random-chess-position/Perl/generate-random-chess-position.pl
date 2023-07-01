use strict;
use warnings;
use feature 'say';
use utf8;
use List::AllUtils <shuffle any natatime>;

sub pick1 { return @_[rand @_] }

sub gen_FEN {
    my $n = 1 + int rand 31;
    my @n = (shuffle(0 .. 63))[1 .. $n];

    my @kings;

  KINGS: {
    for my $a (@n) {
        for my $b (@n) {
            next unless $a != $b && abs(int($a/8) - int($b/8)) > 1 || abs($a%8 - $b%8) > 1;
            @kings = ($a, $b);
            last KINGS;
        }
        die 'No good place for kings!';
    }
    }

    my ($row, @pp);
    my @pieces = <p P n N b B r R q Q>;
    my @k      = rand() < .5 ? <K k> : <k K>;

    for my $sq (0 .. 63) {
        if (any { $_ == $sq } @kings) {
            push @pp, shift @k;
        }
        elsif (any { $_ == $sq } @n) {
            $row = 7 - int $sq / 8;
            push @pp,
                $row == 0 ? pick1(grep { $_ ne 'P' } @pieces)
              : $row == 7 ? pick1(grep { $_ ne 'P' } @pieces)
              :             pick1(@pieces);
        }
        else {
            push @pp, 'ø';
        }
    }

    my @qq;
    my $iter = natatime 8, @pp;
    while (my $row = join '', $iter->()) {
        $row =~ s/((ø)\2*)/length($1)/eg;
        push @qq, $row;
    }
    return join('/', @qq) . ' w - - 0 1';
}

say gen_FEN();
