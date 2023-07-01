my $file = 'unixdict.txt';

my @words = $file.IO.slurp.words.race.map: { $_ => .comb.Bag };

.say for (6...2).map: -> $n {
    next unless my @iso = @words.race.grep({.value.values.all == $n})».key;
    "\n({+@iso}) {$n}-isograms:\n" ~ @iso.sort({[-.chars, ~$_]}).join: "\n";
}

my $minchars = 10;

say "\n({+$_}) heterograms with more than $minchars characters:\n" ~
  .sort({[-.chars, ~$_]}).join: "\n" given
  @words.race.grep({.key.chars >$minchars && .value.values.max == 1})».key;
