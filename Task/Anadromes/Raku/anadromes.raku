my @words = 'words.txt'.IO.slurp.words.grep: *.chars > 6;

my %words = @words.pairs.invert;

put join "\n", @words.map: { %words{$_}:delete and sprintf "%10s ↔ %s", $_, .flip if ($_ ne .flip) && %words{.flip} }
