(* Attributes and values *)
val str_attributes = Vector.fromList ["Color",    "Nation",  "Drink", "Pet",        "Smoke"]
val str_colors     = Vector.fromList ["Red",      "Green",   "White", "Yellow",     "Blue"]
val str_nations    = Vector.fromList ["English",  "Swede",   "Dane",  "German",     "Norwegian"]
val str_drinks     = Vector.fromList ["Tea",      "Coffee",  "Milk",  "Beer",       "Water"]
val str_pets       = Vector.fromList ["Dog",      "Birds",   "Cats",  "Horse",      "Zebra"]
val str_smokes     = Vector.fromList ["PallMall", "Dunhill", "Blend", "BlueMaster", "Prince"]

val (Color, Nation, Drink, Pet, Smoke)             = (0, 1, 2, 3, 4)	(* Attributes *)
val (Red, Green, White, Yellow, Blue)              = (0, 1, 2, 3, 4)	(* Color      *)
val (English, Swede, Dane, German, Norwegian)      = (0, 1, 2, 3, 4)	(* Nation     *)
val (Tea, Coffee, Milk, Beer, Water)               = (0, 1, 2, 3, 4)	(* Drink      *)
val (Dog, Birds, Cats, Horse, Zebra)               = (0, 1, 2, 3, 4)	(* Pet        *)
val (PallMall, Dunhill, Blend, BlueMaster, Prince) = (0, 1, 2, 3, 4)	(* Smoke      *)

type attr    = int
type value   = int
type houseno = int

(* Rules *)
datatype rule =
	  AttrPairRule of (attr * value) * (attr * value)
	| NextToRule   of (attr * value) * (attr * value)
	| LeftOfRule   of (attr * value) * (attr * value)

(* Conditions *)
val rules = [
AttrPairRule ((Nation, English), (Color, Red)),		(* #02 *)
AttrPairRule ((Nation, Swede), (Pet, Dog)),		(* #03 *)
AttrPairRule ((Nation, Dane), (Drink, Tea)), 		(* #04 *)
LeftOfRule   ((Color, Green), (Color, White)),		(* #05 *)
AttrPairRule ((Color, Green), (Drink, Coffee)),		(* #06 *)
AttrPairRule ((Smoke, PallMall), (Pet, Birds)),		(* #07 *)
AttrPairRule ((Smoke, Dunhill), (Color, Yellow)),	(* #08 *)
NextToRule   ((Smoke, Blend), (Pet, Cats)),		(* #11 *)
NextToRule   ((Smoke, Dunhill), (Pet, Horse)),		(* #12 *)
AttrPairRule ((Smoke, BlueMaster), (Drink, Beer)),	(* #13 *)
AttrPairRule ((Nation, German), (Smoke, Prince)),	(* #14 *)
NextToRule   ((Nation, Norwegian), (Color, Blue)),	(* #15 *)
NextToRule   ((Smoke, Blend), (Drink, Water))]		(* #16 *)


type house = value option * value option * value option * value option * value option

fun houseval ((a, b, c, d, e) : house, 0 : attr) = a
  | houseval ((a, b, c, d, e) : house, 1 : attr) = b
  | houseval ((a, b, c, d, e) : house, 2 : attr) = c
  | houseval ((a, b, c, d, e) : house, 3 : attr) = d
  | houseval ((a, b, c, d, e) : house, 4 : attr) = e
  | houseval _ = raise Domain

fun sethouseval ((a, b, c, d, e) : house, 0 : attr, a2 : value option) = (a2, b,  c,  d,  e )
  | sethouseval ((a, b, c, d, e) : house, 1 : attr, b2 : value option) = (a,  b2, c,  d,  e )
  | sethouseval ((a, b, c, d, e) : house, 2 : attr, c2 : value option) = (a,  b,  c2, d,  e )
  | sethouseval ((a, b, c, d, e) : house, 3 : attr, d2 : value option) = (a,  b,  c,  d2, e )
  | sethouseval ((a, b, c, d, e) : house, 4 : attr, e2 : value option) = (a,  b,  c,  d,  e2)
  | sethouseval _ = raise Domain

fun getHouseVal houses (no, attr) = houseval (Array.sub (houses, no), attr)
fun setHouseVal houses (no, attr, newval) =
	Array.update (houses, no, sethouseval (Array.sub (houses, no), attr, newval))


fun match (house, (rule_attr, rule_val)) =
	let
	  val value = houseval (house, rule_attr)
	in
	  isSome value andalso valOf value = rule_val
	end

fun matchNo houses (no, rule) =
	 match (Array.sub (houses, no), rule)

fun compare (house1, house2, ((rule_attr1, rule_val1), (rule_attr2, rule_val2))) =
	let
	  val val1 = houseval (house1, rule_attr1)
	  val val2 = houseval (house2, rule_attr2)
	in
	  if isSome val1 andalso isSome val2
	  then (valOf val1 = rule_val1 andalso valOf val2 <> rule_val2)
	         orelse
	       (valOf val1 <> rule_val1 andalso valOf val2 = rule_val2)
	  else false
	end

fun compareNo houses (no1, no2, rulepair) =
	compare (Array.sub (houses, no1), Array.sub (houses, no2), rulepair)


fun invalid houses no (AttrPairRule rulepair) =
	compareNo houses (no, no, rulepair)

  | invalid houses no (NextToRule rulepair) =
  	(if no > 0
	 then compareNo houses (no, no-1, rulepair)
	 else true)
	andalso
	(if no < 4
	 then compareNo houses (no, no+1, rulepair)
	 else true)

  | invalid houses no (LeftOfRule rulepair) =
  	if no > 0
	then compareNo houses (no-1, no, rulepair)
	else matchNo houses (no, #1rulepair)


(*
 * val checkRulesForNo : house vector -> houseno -> bool
 * Check all rules for a house;
 * Returns true, when one rule was invalid.
 *)
fun checkRulesForNo (houses : house array) no =
	let
	  exception RuleError
	in
	  (map (fn rule => if invalid houses no rule then raise RuleError else ()) rules;
	   false)
	  handle RuleError => true
	end

(*
 * val checkAll : house vector -> bool
 * Check all rules;
 * return true if everything is ok.
 *)
fun checkAll (houses : house array) =
	let
	  exception RuleError
	in
	  (map (fn no => if checkRulesForNo houses no then raise RuleError else ()) [0,1,2,3,4];
	   true)
	  handle RuleError => false
	end


(*
 *
 * House printing for debugging
 *
 *)

fun valToString (0, SOME a) = Vector.sub (str_colors,  a)
  | valToString (1, SOME b) = Vector.sub (str_nations, b)
  | valToString (2, SOME c) = Vector.sub (str_drinks,  c)
  | valToString (3, SOME d) = Vector.sub (str_pets,    d)
  | valToString (4, SOME e) = Vector.sub (str_smokes,  e)
  | valToString _ = "-"

(*
 * Note:
 * Format needs SML NJ
 *)
fun printHouse no ((a, b, c, d, e) : house) =
	(
	  print (Format.format "%12d" [Format.LEFT (12, Format.INT no)]);
	  print (Format.format "%12s%12s%12s%12s%12s"
	  	(map (fn (x, y) => Format.LEFT (12, Format.STR (valToString (x, y))))
			[(0,a), (1,b), (2,c), (3,d), (4,e)]));
	  print ("\n")
	)

fun printHouses houses =
	(
	  print (Format.format "%12s" [Format.LEFT (12, Format.STR "House")]);
	  Vector.map (fn a => print (Format.format "%12s" [Format.LEFT (12, Format.STR a)]))
	  	str_attributes;
	  print "\n";
	  Array.foldli (fn (no, house, _) => printHouse no house) () houses
	)

(*
 *
 * Solving
 *
 *)

exception SolutionFound

fun search (houses : house array, used : bool Array2.array) (no : houseno, attr : attr) =
	let
	  val i = ref 0
	  val (nextno, nextattr) = if attr < 4 then (no, attr + 1) else (no + 1, 0)
	in
	  if isSome (getHouseVal houses (no, attr))
	  then
	  (
	    search (houses, used) (nextno, nextattr)
	  )
	  else
	  (
	    while (!i < 5)
	    do
	    (
	      if Array2.sub (used, attr, !i) then ()
	      else
	      (
	          Array2.update (used, attr, !i, true);
	          setHouseVal houses (no, attr, SOME (!i));

	          if checkAll houses then
	          (
	            if no = 4 andalso attr = 4
	            then raise SolutionFound
	            else search (houses, used) (nextno, nextattr)
	          )
	          else ();
	          Array2.update (used, attr, !i, false)
	      ); (* else *)
	      i := !i + 1
	    ); (* do *)
	    setHouseVal houses (no, attr, NONE)
	  ) (* else *)
	end

fun init () =
	let
	  val unknown : house = (NONE, NONE, NONE, NONE, NONE)
	  val houses  = Array.fromList [unknown, unknown, unknown, unknown, unknown]
	  val used    = Array2.array (5, 5, false)
	in
	  (houses, used)
	end

fun solve () =
	let
	  val (houses, used) = init()
	in
	  setHouseVal houses (2, Drink, SOME Milk);		(* #09 *)
	  Array2.update (used, Drink, Milk, true);
	  setHouseVal houses (0, Nation, SOME Norwegian);	(* #10 *)
	  Array2.update (used, Nation, Norwegian, true);
	  (search (houses, used) (0, 0); NONE)
	  handle SolutionFound => SOME houses
	end

(*
 *
 * Execution
 *
 *)

fun main () = let
	  val solution = solve()
	in
	  if isSome solution
	  then printHouses (valOf solution)
	  else print "No solution found!\n"
	end
