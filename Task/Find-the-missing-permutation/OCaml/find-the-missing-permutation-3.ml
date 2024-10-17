let array_of_perm s =
	let n = String.length s in
	Array.init n (fun i -> int_of_char s.[i] - 65);;
	
let perm_of_array a =
	let n = Array.length a in
	let s = String.create n in
	Array.iteri (fun i x ->
		s.[i] <- char_of_int (x + 65)
	) a;
	s;;

let find_missing v =
	let n = String.length (List.hd v) in
	let a = Array.make_matrix n n 0
	and r = ref v in
	List.iter (fun s ->
		let u = array_of_perm s in
		Array.iteri (fun i x -> x.(u.(i)) <- x.(u.(i)) + 1) a
	) v;
	let q = Array.make n 0 in
	Array.iteri (fun i x ->
		Array.iteri (fun j y ->
			if y mod 2 != 0 then q.(i) <- j
		) x
	) a;
	perm_of_array q;;

find_missing deficient_perms;;
(* - : string = "DBAC" *)
