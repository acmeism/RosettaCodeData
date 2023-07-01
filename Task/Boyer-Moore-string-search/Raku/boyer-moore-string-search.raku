# 20220818 Raku programming solution

sub suffixes (@pat,\m) {
   loop (my ($i,$f,$g,@suff)=m-2, 0, m-1, |flat 0 xx m-1,m; $i >= 0; --$i) {
      if $i > $g and @suff[$i + m - 1 - $f] < $i - $g {
         @suff[$i] = @suff[$i + m - 1 - $f]
      } else {
	 $g = $i if $i < $g;
         $f = $i;
	 while $g >= 0 and @pat[$g] eq @pat[$g + m - 1 - $f] { $g-- }
         @suff[$i] = $f - $g
      }
   }
   return @suff;
}

sub preBmGs (@pat,\m) {
   my (@suff, @bmGs) := suffixes(@pat,m), [m xx m];

   for m-1 ... 0 -> \k {
      if @suff[k] == k + 1 {
         loop (my $j=0; $j < m-1-k; $j++) { @bmGs[k]=m-1-k if @bmGs[$j] == m }
      }
   }
   for ^(m-1) { @bmGs[m - 1 - @suff[$_]] = m - 1 - $_ }
   return @bmGs;
}

sub BM (@txt,@pat) {
   my (\m, \n, $j)    = +@pat, +@txt, 0;
   my (@bmGs, %bmBc) := preBmGs(@pat,m), hash @pat Z=> ( m-1 ... 1 );

   return gather while $j <= n - m {
      loop (my $i = m - 1; $i >= 0 and @pat[$i] eq @txt[$i + $j]; ) { $i-- }
      if $i < 0 {
	 take $j;
         $j += @bmGs[0]
      } else {
         $j += max @bmGs[$i], (%bmBc{@txt[$i + $j]} // m)-m+$i
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

my @pats = [ "TCTA", "TAATAAA", "word", "needle", "ഭാരതം", "put", "and", "alfalfa"];

say "text$_ = @texts[$_]" for @texts.keys ;
say();

for @pats.keys {
   my \j = $_ < 6 ?? $_ !! $_-1 ; # for searching text5 twice
   say "Found '@pats[$_]' in 'text{j}' at indices ", BM @texts[j].comb, @pats[$_].comb
}
