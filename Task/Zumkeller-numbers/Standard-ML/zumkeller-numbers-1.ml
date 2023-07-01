exception Found of string ;

val divisors  = fn n =>
let
 val rec divr = fn  ( c, divlist ,i) =>
    if c <2*i then c::divlist
              else divr  (if c mod i = 0 then (c,i::divlist,i+1)  else (c,divlist,i+1) )
in
   divr  (n,[],1)
end;


val subsetSums = fn M => fn input =>
let
 val getnrs = fn (v,x) =>                                 (* out: list of numbers index where v is true + x *)
  let
     val rec runthr =  fn (v,i,x,lst)=> if i>=M then (v,i,x,lst) else  runthr (v,i+1,x,if Vector.sub(v,i) then (i+x)::lst else lst) ;
  in
     #4 (runthr (v,0,x,[]))
  end;

 val nwVec =  fn  (v,nrs) =>
  let
    val rec upd = fn (v,i,[])   => (v,i,[])
                  | (v,i,h::t)  => upd ( case Int.compare (h,M) of
		            LESS    => ( Vector.update (v,h,true),i+1,t)
		          | GREATER => (v,i+1,t)
		          | EQUAL   => raise Found ("done "^(Int.toString h))  )
  in
    #1 (upd (v,0,nrs))
  end;

 val rec setSums = fn ([],v)  => ([],v)
                   | (x::t,v) => setSums(t, nwVec(v, getnrs (v,x)))
in

  #2 (setSums (input,Vector.tabulate (M+1,fn 0=> true|_=>false) ))

end;


val rec Zumkeller =  fn n =>
  let
   val d    =  divisors n;
   val s    =  List.foldr op+ 0 d ;
   val hs   =  s div 2 -n ;
  in

   if s mod 2 = 1 orelse 0 > hs then false else
       Vector.sub (  subsetSums hs (tl d) ,hs)             handle Found nr => true

end;
