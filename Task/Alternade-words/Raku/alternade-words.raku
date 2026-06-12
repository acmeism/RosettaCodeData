unit sub MAIN ($file = 'unixdict.txt', :$min = 6);

my %words = $file.IO.slurp.words.map: * => 1;

my @alternades;

for %words {
    next if .key.chars < $min;
    my @letters = .key.comb;
    my @alts = @letters[0,2 … *].join, @letters[1,3 … *].join;
    @alternades.push(.key => @alts) if %words{@alts[0]} && %words{@alts[1]};
}

@alternades.=sort;

say "{+@alternades} alternades longer than {$min-1} characters found in $file:";

.say for @alternades > 10
  ?? (flat @alternades.head(5), '...', @alternades.tail(5))
  !! @alternades;
