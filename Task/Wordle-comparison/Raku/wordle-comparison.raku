# 20220216 Raku programming solution

sub wordle (\answer,\guess where [==] (answer,guess)».chars ) {

   my ($aSet, $gSet, @return) = (answer,guess)».&{ (set .comb.pairs).SetHash }

   (my \intersection = $aSet ∩ $gSet).keys».&{ @return[.key] = 'green' }
   ($aSet,$gSet)».&{ $_ ∖= intersection } # purge common subset

   for $gSet.keys.sort -> \trial { # pair
      @return[trial.key] = 'grey';
      for $aSet.keys -> \actual { # pair
         if [eq] (trial,actual)».value {
            @return[trial.key] = 'yellow';
            $aSet{actual}:delete;
            last
         }
         my @NFD = (trial,actual).map: { .value.NFD }
         if [ne] @NFD and [==] @NFD».first {
            @return[trial.key] = 'azure';
            $aSet{actual}:delete;
            last
         }
      }
   }
   @return
}

say .[0]~' vs '~.[1]~"\t"~ wordle .[0],.[1] for (
<ALLOW LOLLY>, <ROBIN ALERT>, <ROBIN SONIC>, <ROBIN ROBIN>, <BULLY LOLLY>,
<ADAPT SÅLÅD>, <Ukraine Ukraíne>, <BBAABBB BBBBBAA>, <BBAABBB AABBBAA> );
