# 20210104 added Perl programming solution

use strict;
use warnings;

my $alternatingCount = 0;

while (<>) {
   (my $Fld1) = split(' ', $_, -1);
   if ((length($Fld1) >= 10)) { # have an arpropriate length word
      my $word = $Fld1;
      my $haveVowel = $word =~ /^[aeiou]/;
      my $isAlternating = 1;
      for (my $wPos = 2; $isAlternating && $wPos <= length($word); $wPos++) {
         my $hadVowel = $haveVowel;
         $haveVowel = substr($word, ($wPos)-1, 1) =~ /^[aeiou]/;
         $isAlternating = ($hadVowel && !$haveVowel) || (!$hadVowel && $haveVowel);
      } # for wPos
      if ($isAlternating) {
          printf ' %16s%s', $word, ($alternatingCount % 6 == 5) ? "\n" : '';
          $alternatingCount += 1;
      } # if isAlternating
   }
}

printf "\n%d words with alternating vowels and consonants found\n", $alternatingCount;
