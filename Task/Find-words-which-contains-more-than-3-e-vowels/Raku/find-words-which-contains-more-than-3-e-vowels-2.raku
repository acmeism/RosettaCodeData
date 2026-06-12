unit sub MAIN ($vowel = 'e', $min = 4, $file = 'unixdict.txt');
.say for squish sort
  ( $file.IO.slurp.words.grep: { ((my $b = .lc.samemark(' ').comb.Bag){$vowel} >= $min) && $b<a e i o u>.sum == $b{$vowel} } )\
  ».subst(/<[":;,.?!_\[\]]>/, '', :g);
