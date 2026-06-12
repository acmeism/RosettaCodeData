use strict;
use warnings;
use feature 'say';

sub query_for_integer {
    my ($prompt) = @_;
    while (1) {
        print "$prompt " and chop($_ = <>);
        /^\d+$/ ? return $_ : say '(need an integer)';
    }
}

sub spoof_for_2 {
    my ($mypot, $myguess, $yourpot, $yourguess) = (0, 0, 0, 0);
    my $ngames = query_for_integer('How many games do you want?');

    for (1 .. $ngames) {

        while (1) {
            $mypot   = 1 + int rand 3;
            $myguess = 1 + int rand 6;
            last if $mypot+3 < $myguess;
        }
        say 'I have set my pot and guess.';

        while (1) {
            $yourpot   = query_for_integer('Your pot?'  );
            $yourguess = query_for_integer('Your guess?');
            last if (0 <= $yourpot and $yourpot <= 6) and (0 <= $yourguess and $yourguess <= 6) and $yourpot+4 > $yourguess;
        }
        say "My pot is: $mypot\nMy guess is: $myguess";
        my $pot = $mypot + $yourpot;
        if ($myguess == $pot and $yourguess == $pot) { say 'Draw!'      }
        elsif ($myguess == $pot)                     { say 'I won!'     }
        elsif ($yourguess == $pot)                   { say 'You won!'   }
        else                                         { say 'No winner!' }
    }
}

spoof_for_2();
