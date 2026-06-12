# 20221025 Raku programming solution

enum <UNTREATED REGULAR IRREGULAR>;
my \DOSE_FOR_REGULAR = 100;
my ($nSubjects,$duration,$interval) = 10000, 180, 30;
my (@dosage,@category,@hadcovid) := (0,UNTREATED,False)>>.&{($_ xx $nSubjects).Array};

sub update($pCovid=1e-3, $pStartTreatment=5e-3, $pRedose=¼, @dRange=<3 6 9>) {
   for 0 ..^ @dosage.elems -> \i {
      unless @hadcovid[i] {
         if rand < $pCovid {
            @hadcovid[i] = True
         } else {
            my $dose = @dosage[i];
            if $dose==0 && rand < $pStartTreatment or $dose > 0 && rand < $pRedose {
	           @dosage[i]   = $dose += @dRange.roll;
               @category[i] = ($dose > DOSE_FOR_REGULAR) ?? REGULAR !! IRREGULAR
            }
         }
      }
   }
}

sub kruskal (@sets) {
   my $n          = ( my @ranked = @sets>>.List.flat.sort ).elems;
   my @sr         = 0 xx @sets.elems;
   my $ix         = (@ranked.first: * == True, :k)+1,
   my ($arf,$art) = ($ix, $ix+$n) >>/>> 2;

   for @sets.kv -> \i,@set { for @set -> $b { @sr[i] += $b ?? $art !! $arf } }

   my $H = [+] @sr.kv.map: -> \i,\s { s*s/@sets[i].elems }
   return 12/($n*($n+1)) * $H - 3 * ($n + 1)
}

say "Total subjects: $nSubjects\n";

my ($midpoint,$unt,$irr,$reg,$hunt,$hirr,$hreg,@sunt,@sirr,@sreg)=$duration div 2;

for 1 .. $duration -> \day {
   update();
   if day %% $interval or day == $duration or day == $midpoint {
      @sunt = @hadcovid[ @category.grep: UNTREATED,:k ];
      @sirr = @hadcovid[ @category.grep: IRREGULAR,:k ];
      @sreg = @hadcovid[ @category.grep: REGULAR,  :k ];
      ($unt,$hunt,$irr,$hirr,$reg,$hreg)=(@sunt,@sirr,@sreg).map:{|(.elems,.sum)}
   }
   if day %% $interval {
      printf "Day %d:\n",day;
      printf "Untreated:     N = %4d, with infection = %4d\n",  $unt,$hunt;
      printf "Irregular Use: N = %4d, with infection = %4d\n",  $irr,$hirr;
      printf "Regular Use:   N = %4d, with infection = %4d\n\n",$reg,$hreg
   }
   if day == $midpoint | $duration {
      my $stage = day == $midpoint ?? 'midpoint' !! 'study end';
      printf "At $stage, Infection case percentages are:\n";
      printf "  Untreated : %f\n",  100*$hunt/$unt;
      printf "  Irregulars: %f\n",  100*$hirr/$irr;
      printf "  Regulars  : %f\n\n",100*$hreg/$reg
   }
}

printf "Final statistics: H = %f\n", kruskal ( @sunt, @sirr, @sreg )
