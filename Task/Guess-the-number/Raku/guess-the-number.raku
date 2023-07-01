my $number = (1..10).pick;
repeat {} until prompt("Guess a number: ") == $number;
say "Guessed right!";
