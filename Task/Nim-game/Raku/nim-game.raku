say my $tokens = 12, " tokens remaining.\n";

loop {
    my $player = trim prompt "How many tokens do you want to remove; 1, 2 or 3? : ";
    say "Nice try. $tokens tokens remaining.\n" and
    next unless $player eq any <1 2 3>;
    $tokens -= 4;
    say "Computer takes {4 - $player}.\n$tokens tokens remaining.\n";
    say "Computer wins." and last if $tokens <= 0;
}
