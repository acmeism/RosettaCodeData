# 20220123 Raku programming solution

# Proof :
#
#    H-----------A---------B-------C-----D---E
#    |                                       |
#    |                                       |
#    |                                       |
#    O---------------------------------------L
#
#    ▲OEL is unique as its area is the sum of the rest.
#
#    and also in terms of area ▲OHA > ▲OAB > ... > ▲ODE


sub UnequalDivider (\L,\H,\N where N > 2) {

   my \sum = $ = 0 ; my \part = $ = 0 ; my @sequence = (N^...1) ;

   loop {                                               #   if  ▲OHA ~ ▲OEL
      sum  = @sequence.sum;                             #   increase 1st term
      @sequence[0]*L*L/sum == H*H ?? (@sequence[0] +=1) !! last
   }

   (  [ (0,0), (L,H), (L,0) ],  ).Array.append: @sequence.map: -> \chunk {
      [ (0,0), (L*part/sum,H), (L*(part+=chunk)/sum,H) ] ;
   }
}

.say for UnequalDivider(1000,500,5);
