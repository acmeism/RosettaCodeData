val factor = fn n :IntInf.int  =>
let
 val unfactored  = fn (u,_,_)   => u
 val factors     = fn (_,f,_)   => f
 val try         = fn (_,_,i)   => i
 fun getresult t = unfactored t::(factors t)

 fun until done change x =
    if done x
      then    getresult x
      else    until done change (change x);       (* iteration *)

 fun lastprime t = unfactored t  <  (try t)*(try t)
 fun trymore t   = if unfactored t mod (try t) = 0
           then (unfactored t div (try t) , try t::(factors t) , try t    )
       else (unfactored t             ,         factors t  , try t + 1)
in

 until lastprime trymore (n,[],2)

end;
