(* Task : RPG_attributes_generator *)

(*
	A programmatic solution to generating character attributes for an RPG
*)

(* Generates random whole values between 1 and 6. *)
let rand_die () : int = Random.int 6

(* Generates 4 random values and saves the sum of the 3 largest *)
let rand_attr () : int =
	let four_rolls = [rand_die (); rand_die (); rand_die (); rand_die ()]
		|> List.sort compare in
	let three_best = List.tl four_rolls in
	List.fold_left (+) 0 three_best

(* Generates a total of 6 values this way. *)
let rand_set () : int list=
	[rand_attr (); rand_attr (); rand_attr ();
	rand_attr (); rand_attr (); rand_attr ()]

(* Verifies conditions: total >= 75, at least 2 >= 15 *)
let rec valid_set () : int list=
	let s = rand_set () in
	let above_15 = List.fold_left (fun acc el -> if el >= 15 then acc + 1 else acc) 0 s in
	let total = List.fold_left (+) 0 s in
	if above_15 >= 2 && total >= 75
	then s
	else valid_set ()

(*** Output ***)

let _ =
	let s = valid_set () in
	List.iter (fun i -> print_int i; print_string ", ") s
