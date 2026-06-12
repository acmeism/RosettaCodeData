my @players = (1,0)[$_%2] .. $_ given 12;
my $half = +@players div 2;
my $round = 0;

loop {
    printf "Round %2d: %s\n", ++$round, "{ zip( @players[^$half], @players[$half..*].reverse ).map: { sprintf "(%2d vs %-2d)", |$_ } }";
    @players[1..*].=rotate(-1);
    last if [<] @players;
}
