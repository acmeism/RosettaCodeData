use strict;
use warnings;
use feature 'say';

my $tokens = 12;
say "$tokens tokens remaining.\n";

while (1) {
    print "How many tokens do you want to remove; 1, 2 or 3? : ";
    (my $player = <>) =~ s/\s//g;
    say "Nice try. $tokens tokens remaining.\n" and next
        unless $player =~ /^[123]$/;
    $tokens -= 4;
    say "Computer takes @{[4 - $player]}.\n$tokens tokens remaining.\n";
    say "Computer wins." and last
        if $tokens <= 0;
}
