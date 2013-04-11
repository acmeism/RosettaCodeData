my $game_number = @*ARGS.shift || 1;

sub ms_lcg_method  ($seed) { ( 214013 * $seed + 2531011 ) % 2**31 };

# lazy list of the random sequence
my @ms_lcg := gather take $_ +> 16
        for ( $game_number.&ms_lcg_method, -> $seed { $seed.&ms_lcg_method } ... * );

my @deck = <A 2 3 4 5 6 7 8 9 T J Q K> X~ <♣ ♦ ♥ ♠>;

my @game = gather while @deck {
        my $index = @ms_lcg.shift % @deck;
        take @deck[$index];
        @deck[$index] = @deck.pop;
}

say "Game #$game_number";
say @game.splice(0, min(@game.elems, 8)) while @game;
