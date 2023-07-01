val Entropy = fn input =>
 let
   val   N     = Real.fromInt (String.size input) ;
   val  term   = fn a => Math.ln (a/N) * a  /  ( Math.ln 2.0 * N ) ;
   val   v0    = Vector.tabulate (255,fn i=>0)   ;
   val  freq   = Vector.map Real.fromInt                                         (* List.foldr:  count occurrences  *)
                   (List.foldr   (fn (i,v) => Vector.update( v, ord i, Vector.sub(v,ord i) + 1) ) v0 (explode input) )
 in

      ~ (Vector.foldr  (fn (a,s) => if a > 0.0 then term a  + s else s)  0.0  freq )

end ;
