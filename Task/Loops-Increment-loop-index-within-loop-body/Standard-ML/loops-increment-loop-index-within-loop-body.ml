fun until done change dolast x =
    if done x
      then    dolast x
      else    until done change dolast (change x);       (* iteration/generic loop *)


val isprime = fn n :IntInf.int  =>
let
 fun butlast (_,t)   = t*t > n
 fun divide (n,t)    = n mod t = 0 orelse t*t > n
 fun trymore (n,t)   = (n,t + 2)
in

 n mod 2 <> 0 andalso until divide trymore butlast (n,3)

end;

val loop =  fn () =>
let
 fun butthislast (_,p,_) = rev p
 fun wegot42 (n,_,_)     = n = 43
 fun trymore (n,p,i)     = if isprime i
                                   then ( n+1, (n,i)::p , i+i )
                                   else ( n ,  p, i+1)
in

  until wegot42 trymore butthislast  (1,[],42)

end ;

val printp = fn clist:(int*IntInf.int) list =>
 List.app (fn i=>print ((Int.toString (#1 i) )^" : "^ (IntInf.toString (#2 i) )^"\n")) clist ;
