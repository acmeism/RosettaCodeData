sub prime-group-count ($_) {
   +(.ords.sort.reverse.combinations(4).grep: {
        next if .[0]-.[*-1] != 7;
        .rotor(2 => -1).map({[-] $_}).List eqv (2,3,2)
   })
   +(.ords.combinations(3).grep: { all .combinations(2).map: { ([-] $_).abs.is-prime } })
   +(.ords.combinations(2).grep: { ([-] $_).abs.is-prime })
}

# Testing: the two every other entry has, and all ASCII printable characters
say "$_ ⇒ ", .&prime-group-count for 'abcdef', 'abcdefgh', 'abcdefghijklmnopqrstuvwxyz', (32..126).chrs.join;

# User input
loop {
   my $word = prompt "\nEnter some text:> ";
   exit unless $word.chars;
   say "$word ⇒ ", prime-group-count $word;
}
