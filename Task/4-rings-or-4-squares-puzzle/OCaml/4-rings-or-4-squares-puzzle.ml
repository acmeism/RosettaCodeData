(* Task : 4-rings_or_4-squares_puzzle *)

(*
	Replace a, b, c, d, e, f, and g with the decimal digits LOW ───► HIGH
	such that the sum of the letters inside of each of the four large squares add up to the same sum.

	Squares are: ab; bcd; def; fg
	Solution: brute force from generating a, b, d, g from possible range
*)

(*** Helpers ***)

type assignment = {
	a: int;
	b: int;
	c: int;
	d: int;
	e: int;
	f: int;
	g: int;
}

let generate ((a, b), (d, g)) =
	let s = a + b in
	let c = s - b - d in
	let f = s - g in
	let e = s - f - d in
	{a; b; c; d; e; f; g}

let list_of_assign assign =
	[assign.a; assign.b; assign.c; assign.d; assign.e; assign.f; assign.g]

let test unique low high assign =
	let l = list_of_assign assign in
	let test_el e =
		e >= low && e <= high &&
		(not unique || (l |> List.filter ((=) e) |> List.length) == 1)
	in
	List.for_all test_el l

let generator low high =
	let single () = Seq.ints low |> Seq.take_while (fun x -> x <= high) in
	let first_two = Seq.product (single ()) (single ()) in
	let second_two = Seq.product (single ()) (single ()) in
	let final = Seq.product first_two second_two in
	Seq.map generate final

let print_assign a =
	Printf.printf "a: %d, b: %d, c: %d, d: %d, e: %d, f: %d, g: %d\n"
		a.a a.b a.c a.d a.e a.f a.g

(*** Actual task at hand ***)

let evaluate low high unique log =
	let seqs = generator low high |> Seq.filter (test unique low high) in
	let unique_str = if unique then "unique" else "non-unique" in
	if log then Seq.iter print_assign seqs;
	Printf.printf "%d %s sequences found between %d and %d\n\n" (Seq.length seqs) unique_str low high

(*** Output ***)

let () =
	evaluate 1 7 true true;
	evaluate 3 9 true true;
	evaluate 0 9 false false
;;
