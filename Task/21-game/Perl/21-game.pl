print <<'HERE';
The 21 game. Each player chooses to add 1, 2, or 3 to a running total.
The player whose turn it is when the total reaches 21 wins. Enter q to quit.
HERE

my $total = 0;

while () {
    print "Running total is: $total\n";
    my ($me,$comp);
    while () {
        print 'What number do you play> ';
        $me = <>; chomp $me;
        last if $me =~ /^[123]$/;
        insult($me);
    }
    $total += $me;
    win('Human') if $total >= 21;
    print "Computer plays: " . ($comp = 1+int(rand(3))) . "\n";
    $total += $comp;
    win('Computer') if $total >= 21;
}

sub win {
    my($player) = @_;
    print "$player wins.\n";
    exit;
}

sub insult {
    my($g) = @_;
    exit if $g =~ /q/i;
    my @insults = ('Yo mama', 'Jeez', 'Ummmm', 'Grow up');
    my $i = $insults[1+int rand($#insults)];
    print "$i, $g is not an integer between 1 and 3...\n"
}
