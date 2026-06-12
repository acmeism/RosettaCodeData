load 'format/printf'

pso_init =: verb define
   'Min Max parameters nParticles' =. y
   'Min: %j\nMax: %j\nomega, phip, phig: %j\nnParticles: %j\n' printf Min;Max;parameters;nParticles
   nDims =. #Min
   pos =. Min +"1 (Max - Min) *"1 (nParticles,nDims) ?@$ 0
   bpos =. pos
   bval =. (#pos) $ _
   vel  =. ($pos) $ 0
   0;_;_;Min;Max;parameters;pos;vel;bpos;bval      NB. initial state
)

pso =: adverb define
   NB. previous state
   'iter gbpos gbval Min Max parameters pos vel bpos0 bval' =. y

   NB. evaluate
   val    =. u"1 pos

   NB. update
   better =. val < bval
   bpos   =. (better # pos) (I. better)} bpos0
   bval   =. u"1 bpos
   gbval  =. <./ bval
   gbpos  =. bpos {~ (i. <./) bval

   NB. migrate
   'omega phip phig' =. parameters
   rp  =. (#pos) ?@$ 0
   rg  =. ? 0
   vel =. (omega*vel) + (phip * rp * bpos - pos) + (phig * rg * gbpos -"1 pos)
   pos =. pos + vel

   NB. reset out-of-bounds particles
   bad    =. +./"1 (Min >"1 pos) ,. (pos >"1 Max)
   newpos =. Min +"1 (Max-Min) *"1 ((+/bad),#Min) ?@$ 0
   pos    =. newpos (I. bad)} pos
   iter   =. >: iter

   NB. new state
   iter;gbpos;gbval;Min;Max;parameters;pos;vel;bpos;bval
)

reportState=: 'Iteration: %j\nGlobalBestPosition: %j\nGlobalBestValue: %j\n' printf 3&{.
