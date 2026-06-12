unit sub MAIN(*@columns, :v(:$verbose)=False);

my @sequences = @columns
              . pairs
              . map({ (.key+1) xx .value })
              . flat
              . permutations
              . map( *.join(',') )
              . unique;

if ($verbose) {
  my @offsets = |0,|(1..@columns).map: { [+] @columns[0..$_-1] };
  my @matrix;
  for ^@columns.max -> $i {
    for ^@columns -> $j {
      my $value = $i < @columns[$j] ?? ($i+@offsets[$j]+1) !! Nil;
      @matrix[$j][$i] = $value if $value;;
      print "\t" ~ ($value // " ");
    }
    say '';
  }
  say "There are {+@sequences} possible takedown sequences:";
  for @sequences».split(',') -> @seq {
    my @work = @matrix».clone;
    my $seq = '[';
    for @seq -> $col {
      $seq ~= @work[$col-1].pop ~ ',';
    }
    $seq ~~ s/','$/]/;
    say $seq;
  }
} else {
  say +@sequences;
}
