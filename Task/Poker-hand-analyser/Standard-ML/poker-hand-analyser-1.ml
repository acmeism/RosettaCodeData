local
val rec ins = fn x : int*'a => fn [] => [x]
                  |  ll as h::t      => if #1 x<= (#1 h) then x::ll else h::ins x t
val rec acount = fn
 (n,a::(b::t)) =>  if a=b then acount (n+1,b::t) else (n,a)::acount(1,b::t)
   |  (n,[t])  =>  [(n,t)]
in                                                                             (* helper count and sort functions *)
  val rec sortBy1st = fn [] => [] | h::t => ins h (sortBy1st t)
  val addcount      = fn ll => acount (1,ll)
end;



val showHand = fn input =>
 let
 exception Cheat of string
                                                                              (* replace a j q k by their numbers *)
 val translateCardstrings = fn inputstr =>
     String.tokens (fn #" "=>true|_=>false) (String.translate (fn #"a"=>"1"| #"j"=>"11"| #"q"=>"12"| #"k"=>"13" | a=>str a ) inputstr )

                                                                 (* parse numbers and characters into int*strings and order those *)
 val parseFacesSuits =  fn cardcodes =>
  sortBy1st (List.map (fn el => (valOf (Int.fromString el ),String.extract (el,String.size el -1,NONE) )) cardcodes )
     handle Option => raise Cheat "parse"

                                                                (* replace the list of face numbers by a list of every face with its count and order it / descending count *)
 val countAndSort =fn li =>
   let   val hand = ListPair.unzip li   in  (rev (sortBy1st (addcount (#1 hand))) , #2 hand ) end;


 val score = fn
   ( (4,_)::t , _ )        => "four-of-a-kind"
 | ( (3,_)::(2,_)::t , _ ) => "full-house"
 | ( (3,_)::t,_)           => "three-of-a-kind"
 | ( (2,_)::(2,_)::t,_)    => "two-pair"
 | ( (2,_)::t,_)           => "one-pair"
 | (x as (1,_)::t,ll)      => if  #2 (hd x ) - (#2 (hd (rev x))) =4 orelse ( #2 (hd (rev x))  = 1 andalso #2 (hd (tl (rev x))) =10 )
                                 then
                                    if  List.all (fn x => hd ll=x) ll
			              then "straight-flush"
			              else "straight"
			         else if  List.all (fn x => hd ll=x) ll then "flush" else  "high-card"
 | _                       => "invalid"



                                                                      (* return 'invalid' if any duplicates or invalid codes *)
 val validate = fn lpair : (int * string) list =>
   let val rec uniq = fn ([],y) =>true|(x,y) => List.filter (fn a=>a= hd x) y = [hd x] andalso uniq(tl x,y)
   in
    if         List.all (fn x :int*string  =>  #1 x > 0 andalso  #1 x < 14 )  lpair
      andalso  List.all (fn (x) => Option.isSome ( List.find (fn a=> a= #2x) ["c","d","h","s"] ) )  lpair
      andalso  uniq (lpair ,lpair)
    then lpair
    else raise Cheat "value"
   end

in


   ( score o countAndSort  o  validate  o  parseFacesSuits  o  translateCardstrings )  input      handle Cheat ch => "invalid"

end;
