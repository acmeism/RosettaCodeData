sub prime-groups ($word, $size = 3) {
   my $group;
   $word.ords.combinations($size).map: { $group = .chrs and last if all .combinations(2).map: { ([-] $_).abs.is-prime } }
   $group // 'Not found.'
}

my @words = <riOtjuoq wjtiOxtj akwercjoeiJ Weej Aek jjgja>;

say "Three character prime groups:";
say .&prime-groups(3) for @words;

say "\nTwo character prime groups:";
say .&prime-groups(2) for @words;
