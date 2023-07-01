(* reuse earlier factorial calculations in dfac, apply to listed arguments in cumlfac *)
(* example: left factorial n, is #3 (dfac (0,n-1,1,1) ) *)
(* output list contains (number, factorial, left factorial) *)
(* tested in PolyML *)


val store = ref 0;

val rec dfac = fn
        (from,to,acc,cm) => if from = to then (from,acc,cm) else (store:=(from+1)*acc;dfac (from+1,to,!store,!store+cm ) );

val rec cumlfac = fn
        (x::y::rm) => x :: cumlfac ( dfac (#1 x, #1 y, #2 x, #3 x) :: rm ) |
        rm =>rm ;

val arguments = List.tabulate (10,fn 0=>(0,1,1)|i=>(i,0,0)) @
                List.tabulate (10,fn i=> (10*i+19,0,0) )    @
                List.tabulate ( 10,fn i=> (1000*i+999,0,0));

val result = (~1,0,0)::(cumlfac arguments);

(* done *)
(* display: *)

List.app (fn triple :int*int*int =>
        print(Int.toString (1+ #1 triple ) ^ " : " ^ Int.fmt StringCvt.DEC (#3 triple ) ^" \n" )
        ) (List.take(result,21)  ) ;
List.app (fn triple :int*int*int =>
        print( Int.toString (1+ #1 triple ) ^ " : " ^ Int.toString  (size(Int.toString (#3 triple ))) ^" \n" ) ) (List.drop(result,21)  );
