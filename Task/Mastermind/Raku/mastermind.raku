sub MAIN (
    Int :$colors  where 1 < * < 21 = 6,  Int :$length  where 3 < * < 11 = 4,
    Int :$guesses where 7 < * < 21 = 10, Bool :$repeat = False
  ) {
    my @valid = ('A' .. 'T')[^$colors];
    my $puzzle = $repeat ?? @valid.roll($length) !! @valid.pick($length);
    my @guesses;

    my $black = '●';
    my $white = '○';

    loop {
        clearscr();
        say header();
        printf " %{$length * 2}s :: %s\n", @guesses[$_][0], @guesses[$_][1] for ^@guesses;
        say '';
        lose() if @guesses == $guesses;
        my $guess = get-guess();
        next unless $guess.&is-valid;
        my $score = score($puzzle, $guess);
        win() if $score eq ($black xx $length).join: ' ';
        @guesses.push: [$guess, $score];
    }

    sub header {
        my $num = $guesses - @guesses;
        qq:to/END/;
        Valid letter, but wrong position: ○ - Correct letter and position: ●
        Guess the {$length} element sequence containing the letters {@valid}
        Repeats are {$repeat ?? '' !! 'not '}allowed. You have $num guess{ $num == 1 ?? '' !! 'es'} remaining.
        END
    }

    sub score ($puzzle, $guess) {
        my @score;
        for ^$length {
            if $puzzle[$_] eq $guess[$_] {
                @score.push: $black;
            }
            elsif $puzzle[$_] eq any(@$guess) {
                @score.push: $white;
            }
            else {
                @score.push('-');
            }
        }
        @score.sort.reverse.join: ' ';
    }

    sub clearscr { $*KERNEL ~~ /'win32'/ ?? run('cls') !! run('clear') }

    sub get-guess { (uc prompt 'Your guess?: ').comb(/@valid/) }

    sub is-valid (@guess) { so $length == @guess }

    sub win  { say 'You Win! The correct answer is: ', $puzzle; exit }

    sub lose { say 'Too bad, you ran out of guesses. The solution was: ', $puzzle; exit }
}
