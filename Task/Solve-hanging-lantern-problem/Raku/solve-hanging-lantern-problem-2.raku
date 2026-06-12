unit sub MAIN(*@columns, :v(:$verbose)=False);

my @sequences = @columns
              . pairs
              . map({ (.key+1) xx .value })
              . flat
              . permutations
              . map( *.join(',') )
              . unique;

if ($verbose) {
  say "There are {+@sequences} possible takedown sequences:";
  say "[$_]" for @sequences;
} else {
  say +@sequences;
}
