my $size = 4;
my @secret = pick $size, '1' .. '9';

for 1..* -> $guesses {
    my @guess;
    loop {
        @guess = (prompt("Guess $guesses: ") // exit).comb;
        last if @guess == $size and
            all(@guess) eq one(@guess) & any('1' .. '9');
        say 'Malformed guess; try again.';
    }
    my ($bulls, $cows) = 0, 0;
    for ^$size {
        when @guess[$_] eq @secret[$_] { ++$bulls; }
        when @guess[$_] eq any @secret { ++$cows; }
    }
    last if $bulls == $size;
    say "$bulls bulls, $cows cows.";
}

say 'A winner is you!';
