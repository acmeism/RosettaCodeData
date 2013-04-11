my $s = "In olden times when wishing still helped one, there lived a king
whose daughters were all beautiful, but the youngest was so beautiful
that the sun itself, which has seen so much, was astonished whenever
it shone in her face.  Close-by-the-king's-castle-lay-a-great-dark
forest, and under an old lime-tree in the forest was a well, and when
the day was very warm, the king's child went out into the forest and
sat down by the side of the cool fountain, and when she was bored she
took a golden ball, and threw it up on high and caught it, and this
ball was her favorite plaything.";

$s ~~ s:g/»\s+/ /;
$s ~~ s/\s*$/\n\n/;

say $s.subst(/ \s* (. ** 1..66) \s /, -> $/ { "$0\n" }, :g);
say $s.subst(/ \s* (. ** 1..25) \s /, -> $/ { "$0\n" }, :g);
