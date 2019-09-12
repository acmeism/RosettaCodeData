my @words = <Enjoy Rosetta Code>;
@words.race(:batch(1)).map: { sleep rand; say $_ };
