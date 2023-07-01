use v5.36;
use List::AllUtils <min max zip_by>;

sub suffixes ($m,@pat) {
   my($f, $g) = (0, $m-1);
   my @suff = (0) x $m-1; push @suff, $m;
   for (my $i = $m-2; $i >= 0; --$i) {
      if ($i > $g and $suff[$i + $m - 1 - $f] < $i - $g) {
         $suff[$i] = $suff[$i + $m - 1 - $f]
      } else {
         $g = $i if $i < $g;
         $f = $i;
         while ($g >= 0 and $pat[$g] eq $pat[$g + $m - 1 - $f]) { $g-- }
         $suff[$i] = $f - $g
      }
   }
   @suff
}

sub preBmGs ($m,@pat) {
   my @suff = suffixes($m,@pat);
   my @bmGs = ($m) x $m;

   for my $k (reverse 0..$m-2) {
      if ($suff[$k] == $k + 1) {
         for (my $j=0; $j < $m-1-$k; $j++) { $bmGs[$k]=$m-1-$k if $bmGs[$j] == $m }
      }
   }
   for (0..$m-2) { $bmGs[$m - 1 - $suff[$_]] = $m - 1 - $_ }
   @bmGs
}

sub BM ($txt,$pat) {
    my @txt = split '', $txt;
    my @pat = split '', $pat;
    my ($m, $n, $j)    = (length($pat), length($txt), 0);
    my @bmGs = preBmGs($m,@pat);

    my $x = min $m-1, $#pat;
    my %bmBc = zip_by { @_ } [@pat[0..$x-1]], [reverse 1..$x];

    my @I;
    while ($j <= $n - $m) {
        my $i = $m - 1;
        for (; $i >= 0 and $pat[$i] eq $txt[$i + $j]; ) { $i-- }
        if ($i < 0) {
            push @I, $j;
            $j += $bmGs[0]
        } else {
            $j += max $bmGs[$i], ($bmBc{$txt[$i + $j]} // $m)-$m+$i
        }
    }
    @I
}

my @texts = (
   "GCTAGCTCTACGAGTCTA",
   "GGCTATAATGCGTA",
   "there would have been a time for such a word",
   "needle need noodle needle",   "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented",
   "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk.",
);
my @pats = <TCTA TAATAAA word needle put and alfalfa>;

say "text$_ = $texts[$_]" for 0..$#texts;
say '';

for (0.. $#pats) {
   my $j = $_ < 5 ? $_ : $_-1 ; # for searching text4 twice
   say "Found '$pats[$_]' in 'text$j' at indices " . join ', ', BM($texts[$j],$pats[$_]);
}
