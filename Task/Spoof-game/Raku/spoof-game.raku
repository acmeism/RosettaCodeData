sub query_for_integer ($prompt) { loop { ($_ = prompt "$prompt ") ~~ /^ \d+ $/ ?? return $_ !! say '(need an integer)'; } }

sub spoof_for_2 {
    my ($mypot, $myguess, $yourpot, $yourguess) = 0, 0, 0, 0;
    my $ngames = query_for_integer('How many games do you want?');

    for 1 .. $ngames {

        repeat {
            $mypot   = 1 + 3.rand.Int;
            $myguess = 1 + 6.rand.Int;
        } until $mypot+3 < $myguess;
        say 'I have set my pot and guess.';

        repeat {
            $yourpot   = query_for_integer('Your pot?'  );
            $yourguess = query_for_integer('Your guess?');
        } until 0 <= $yourpot & $yourguess <= 6 and $yourpot+4 > $yourguess;

        say "My pot is: $mypot\nMy guess is: $myguess";

        given $mypot + $yourpot {
            when $myguess & $yourguess { say 'Draw!'      }
            when $myguess              { say 'I won!'     }
            when            $yourguess { say 'You won!'   }
            default                    { say 'No winner!' }
        }
    }
}

spoof_for_2();
