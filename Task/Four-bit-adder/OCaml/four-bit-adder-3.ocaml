(* general adder (n bits with n <= 64) *)
let gen_adder n = block_array serial [|
	mix n 2;
	assoc half_adder (pass (2*n-2));
	block_array serial (Array.init (n-2) (function k ->
		assoc (assoc (pass (k+1)) full_adder) (pass (2*(n-k-2)))));
	assoc (pass (n-1)) full_adder |];;

let gadd_io n = assoc (gen_adder n) (const false (n-1));;

let gen_plus n a b =
	let v = Array.map Int64.to_int
		(eval (gadd_io n) n n (Array.map Int64.of_int [| a; b |])) in
	v.(0), v.(1);;
