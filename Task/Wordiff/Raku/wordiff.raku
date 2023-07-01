my @words = 'unixdict.txt'.IO.slurp.lc.words.grep(*.chars > 2);

my @small = @words.grep(*.chars < 6);

use Text::Levenshtein;

my ($rounds, $word, $guess, @used, @possibles) = 0;

loop {
    my $lev;
    $word = @small.pick;
    hyper for @words  -> $this {
        next if ($word.chars - $this.chars).abs > 1;
        last if ($lev = distance($word, $this)[0]) == 1;
    }
    last if $lev;
}

my $name = ',';

#[[### Entirely unnecessary and unuseful "chatty repartee" but is required by the task

run 'clear';
$name = prompt "Hello player one, what is your name? ";
say "Cool. I'm going to call you Gomer.";
$name = ' Gomer,';
sleep 1;
say "\nPlayer two, what is your name?\nOh wait, this isn't a \"specified number of players\" game...";
sleep 1;
say "Nevermind.\n";

################################################################################]]

loop {
    say "Word in play: $word";
    push @used, $word;
    @possibles = @words.hyper.map: -> $this {
        next if ($word.chars - $this.chars).abs > 1;
        $this if distance($word, $this)[0] == 1 and $this ∉ @used;
    }
    $guess = prompt "your word? ";
    last unless $guess ∈ @possibles;
    ++$rounds;
    say qww<Ok! Woot! 'Way to go!' Nice! 👍 😀>.pick ~ "\n";
    $word = $guess;
}

my $already = ($guess ∈ @used) ?? " $guess was already played but" !! '';

if @possibles {
    say "\nOops. Sorry{$name}{$already} one of [{@possibles}] would have continued the game."
} else {
    say "\nGood job{$name}{$already} there were no possible words to play."
}
say "You made it through $rounds rounds.";
