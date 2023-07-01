use List::Util qw(any);

print 'Enter pool size, puzzle size, attempts allowed: ';
($pool,$length,$tries) = split /\s+/, <>;
$length =  4 if $length eq '' or $length < 3 or $length > 11;
$pool   =  6 if $pool   eq '' or $pool   < 2 or $pool   > 21;
$tries  = 10 if $tries  eq '' or $tries  < 7 or $tries  > 21;

@valid  = sort { -1 + 2*int(rand 2) } ('A' .. 'T')[0..$pool-1];
@puzzle = @valid[0..$length-1];

$black = '●';
$white = '○';

while () {
    header();
    print "$_\n" for @guesses;
    lose() if  @guesses == $tries;
    @guess = get_guess();
    next unless is_valid(@guess);
    $score = score(\@puzzle, \@guess);
    win() if $score eq join ' ', ($black) x $length;
    push @guesses, join(' ', @guess) . ' :: ' . $score;
}

sub score {
    local *puzzle = shift;
    local *guess  = shift;
    my @score;
    for $i (0..$length-1) {
        if    (     $puzzle[$i] eq $guess[$i]) { push @score, $black }
        elsif (any {$puzzle[$i] eq $_} @guess) { push @score, $white }
        else                                   { push @score, '-'    }
    }
    join ' ', reverse sort @score;
}

sub header {
    $num = $tries - @guesses;
    print  "Valid letter, but wrong position: ○ - Correct letter and position: ●\n";
    print  "Guess the $length element sequence containing the letters " . join(', ', sort @valid) . "\n";
    printf "Repeats are not allowed. You have $num guess%s remaining\n", $num > 1 ? 'es' : '';
}

sub get_guess { print 'Your guess?: '; $g = <>; return split /\s*/, uc $g }

sub is_valid { $length == @_ }

sub win  { print 'You win! The correct answer is: ' . join(' ',@puzzle) . "\n"; exit }

sub lose { print 'Too bad, you ran out of guesses. The solution was: ' . join(' ',@puzzle) . "\n"; exit }
