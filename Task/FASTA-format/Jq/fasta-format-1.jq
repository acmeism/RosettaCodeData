def fasta:
  foreach (inputs, ">") as $line
    # state: [accumulator, print ]
    ( [null, null];
      if $line[0:1] == ">" then [($line[1:] + ": "), .[0]]
      else [ (.[0] + $line), false]
      end;
      if .[1] then .[1] else empty end )
    ;

fasta
