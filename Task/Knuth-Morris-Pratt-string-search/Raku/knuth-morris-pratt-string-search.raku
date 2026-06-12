# 20220810 Raku programming solution

sub kmp_search (@S where *.Bool, @W where *.Bool) {

   sub kmp_table (@W where *.Bool) {
      loop (my ($pos,$cnd,@T) = 1,0,-1 ; $pos < @W.elems ; ($pos, $cnd)>>++) {
         if @W[$pos] eq @W[$cnd] {
            @T[$pos]  = @T[$cnd]
         } else {
            @T[$pos]  = $cnd;
            while $cnd ≥ 0 and @W[$pos] ne @W[$cnd] { $cnd = @T[$cnd] }
         }
      }
      @T[$pos] = $cnd;
      return @T
   }

   return gather loop (my ($j,$k,@T) = 0,0, |kmp_table @W; $j < @S.elems; ) {
      if @W[$k] eq @S[$j] {
         ($j, $k)>>++;
         if $k == @W.elems {
	    take $j - $k;
            $k = @T[$k]
         }
      } else {
         ($j, $k)>>++ if ($k = @T[$k]) < 0
      }
   }
}

my @texts = [
   "GCTAGCTCTACGAGTCTA",
   "GGCTATAATGCGTA",
   "there would have been a time for such a word",
   "needle need noodle needle",
   "BharôtভাৰতBharôtভারতIndiaBhāratભારતBhāratभारतBhārataಭಾರತBhāratभारतBhāratamഭാരതംBhāratभारतBhāratभारतBharôtôଭାରତBhāratਭਾਰਤBhāratamभारतम्Bārataபாரதம்BhāratamഭാരതംBhāratadēsamభారతదేశం",
   "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented",
   "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk.",
];

my @pats = ["TCTA", "TAATAAA", "word", "needle", "ഭാരതം", "put", "and", "alfalfa"];

say "text$_ = @texts[$_]" for @texts.keys ;
say();

for @pats.keys {
   my \j = $_ < 6 ?? $_ !! $_-1 ; # for searching text5 twice
   say "Found '@pats[$_]' in 'text{j}' at indices ", kmp_search @texts[j].comb, @pats[$_].comb
}
