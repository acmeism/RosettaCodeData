# 20230401 Raku programming solution

my @data=<UL DL RF UB FD BR DB UF DR UR BL FL FDR BLU DLB URB RUF FLD BRD FUL>;
my @goal=<UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR>;

sub printAlg ($x) { #--- Algorithms.

   my $algo  = 'x0F0DN0EB0H00N0B0R0KB0L0QB0G1A1M11C1I1E1OFI2'~
               'DN2IEOB2H22N2B2GRM2MKGB2GLM2QBK23D3EN3E3B3N33H3';
   $algo ~~ s:g
      !(\D*)(\d)!{
      $0 ~ <ILOFCLKHRNQCL OBIRALOBIRAL CEJHPEIMIG DFNRHRDKMQ>[$1]
      #  ~ [~] reverse map { TR/G..R/M..X/ }, " $0".comb }!;
         ~ " $0".trans( ['G'..'R'] => ['M'..'X'] ).flip }!;

   my @algo = $algo.split: ' ';

   #`[[[ or use the following to save some CPU power and time # my @algo = <
      xILOFCLKHRNQCLx  FILOFCLKHRNQCLF    DNILOFCLKHRNQCLTD EBILOFCLKHRNQCLBE
      HILOFCLKHRNQCLN  ILOFCLKHRNQCL      NILOFCLKHRNQCLT   BILOFCLKHRNQCLB
      RILOFCLKHRNQCLX  KBILOFCLKHRNQCLBQ  LILOFCLKHRNQCLR   QBILOFCLKHRNQCLBW
      GOBIRALOBIRALM   AOBIRALOBIRALA     MOBIRALOBIRALS    OBIRALOBIRAL
      COBIRALOBIRALC   IOBIRALOBIRALO     EOBIRALOBIRALE    OFICEJHPEIMIGOFU
      DNCEJHPEIMIGTD   IEOBCEJHPEIMIGBUEO HCEJHPEIMIGN      CEJHPEIMIG
      NCEJHPEIMIGT     BCEJHPEIMIGB       GRMCEJHPEIMIGSXM  MKGBCEJHPEIMIGBMQS
      GLMCEJHPEIMIGSRM QBKCEJHPEIMIGQBW   DFNRHRDKMQ        DDFNRHRDKMQD
      ENDFNRHRDKMQTE   EDFNRHRDKMQE       BDFNRHRDKMQB      NDFNRHRDKMQT
      DFNRHRDKMQ       HDFNRHRDKMQN >; #]]]

   say [~] my @moves = map {
      substr('UDFBLR', (my $ord=.ord-65) % 6, 1) ~ substr("2 '", $ord div 6, 1)
   }, @algo[$x].comb;

   return @moves.elems
}

my $total = 0;

for 1..18 -> $x { #--- Orient.
   until @data[$x] ∈ @goal {
      $total += printAlg $x;
      @data[$x]                 ~~ s/(.)(.+)/$1$0/;
      @data[$x < 12 ?? 0 !! 19] ~~ s/(.+)(.)/$1$0/;
   }
}

for ^41 { #--- Permute.
   for ^20 -> $w {
      next if @data[$w] eq @goal[$w];
      my $x = 0;
      until @data[$w] eq @goal[$x] { $x++ };
      $x < 12 ?? ( @data[0,$x,12,15] = @data[$x,0,15,12] )
              !! ( @data[12,$x]      = @data[$x,12]      );
      $total += printAlg $x+=18 and last
   }
}

say "\nTotal number of moves : $total";
