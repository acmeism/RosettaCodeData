say qq :to 'HERE';
    The 21 game. Each player chooses to add 1, 2, or 3 to a running total.
    The player whose turn it is when the total reaches 21 wins. Enter q to quit.
    HERE

my $total = 0;
loop {
    say "Running total is: $total";
    my ($me,$comp);
    loop {
        $me = prompt 'What number do you play> ';
        last if $me ~~ /^<[123]>$/;
        insult $me;
    }
    $total += $me;
    win('Human') if $total >= 21;
    say "Computer plays: { $comp = (1,2,3).roll }\n";
    $total += $comp;
    win('Computer') if $total >= 21;
}

sub win ($player) {
    say "$player wins.";
    exit;
}

sub insult ($g) {
    exit if $g eq 'q';
    print ('Yo mama,', 'Jeez,', 'Ummmm,', 'Grow up,', 'Did you even READ the instructions?').roll;
    say " $g is not an integer between 1 & 3..."
}
