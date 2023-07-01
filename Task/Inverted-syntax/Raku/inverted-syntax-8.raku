my $answer;
repeat {
    $answer = prompt "Gimme an answer: ";
} until $answer ~~ 42;
