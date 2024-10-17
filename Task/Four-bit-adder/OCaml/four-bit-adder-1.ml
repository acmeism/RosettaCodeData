(* File blocks.ml

A block is just a black box with nin input lines and nout output lines,
numbered from 0 to nin-1 and 0 to nout-1 respectively. It will be stored
in a caml record, with the operation stored as a function. A value on
a line is represented by a boolean value. *)

type block = { nin:int; nout:int; apply:bool array -> bool array };;

(* First we need function for boolean conversion to and from integer values,
mainly for pretty printing of results *)

let int_of_bits nbits v =
	if (Array.length v) <> nbits then failwith "bad args"
	else
		(let r = ref 0L in
		for i=nbits-1 downto 0 do
			r := Int64.add (Int64.shift_left !r 1) (if v.(i) then 1L else 0L)
		done;
		!r);;

let bits_of_int nbits n =
	let v = Array.make nbits false
	and r = ref n in
	for i=0 to nbits-1 do
		v.(i) <- (Int64.logand !r 1L) <> Int64.zero;
		r := Int64.shift_right_logical !r 1
	done;
	v;;

let input nbits v =
	let n = Array.length v in
	let w = Array.make (n*nbits) false in
	Array.iteri (fun i x ->
		Array.blit (bits_of_int nbits x) 0 w (i*nbits) nbits
	) v;
	w;;
	
let output nbits v =
	let nv = Array.length v in
	let r = nv mod nbits and n = nv/nbits in
	if r <> 0 then failwith "bad output size" else
	Array.init n (fun i ->
		int_of_bits nbits (Array.sub v (i*nbits) nbits)
	);;

(* We have a type for blocks, so we need operations on blocks.

assoc:        make one block from two blocks, side by side (they are not connected)
serial:       connect input from one block to output of another block
parallel:     make two outputs from one input passing through two blocks
block_array:  an array of blocks linked by the same connector (assoc, serial, parallel) *)

let assoc a b =
	{ nin=a.nin+b.nin; nout=a.nout+b.nout; apply=function
		bits -> Array.append
			(a.apply (Array.sub bits 0 a.nin))
			(b.apply (Array.sub bits a.nin b.nin)) };;

let serial a b =
	if a.nout <> b.nin then
		failwith "[serial] bad block"
	else
	{ nin=a.nin; nout=b.nout; apply=function
		bits -> b.apply (a.apply bits) };;

let parallel a b =
	if a.nin <> b.nin then
		failwith "[parallel] bad blocks"
	else { nin=a.nin; nout=a.nout+b.nout; apply=function
		bits -> Array.append (a.apply bits) (b.apply bits) };;

let block_array comb v =
	let n = Array.length v
	and r = ref v.(0) in
	for i=1 to n-1 do
		r := comb !r v.(i)
	done;
	!r;;

(* wires

map:     map n input lines on length(v) output lines, using the links out(k)=v(in(k))
pass:    n wires not connected (out(k) = in(k))
fork:    a wire is developed into n wires having the same value
perm:    permutation of wires
forget:  n wires going nowhere
sub:     subset of wires, other ones going nowhere *)

let map n v = { nin=n; nout=Array.length v; apply=function
	bits -> Array.map (function k -> bits.(k)) v };;

let pass n = { nin=n; nout=n; apply=function
	bits -> bits };;

let fork n = { nin=1; nout=n; apply=function
	bits -> Array.make n bits.(0) };;

let perm v =
	let n = Array.length v in
	{ nin=n; nout=n; apply=function
		bits -> Array.init n (function k -> bits.(v.(k))) };;
		
let forget n = { nin=n; nout=0; apply=function
	bits -> [| |] };;

let sub nin nout where = { nin=nin; nout=nout; apply=function
	bits -> Array.sub bits where nout };;

let transpose n p v =
	if n*p <> Array.length v
		then failwith "bad dim"
	else
		let w = Array.copy v in
		for i=0 to n-1 do
			for j=0 to p-1 do
				let r = i*p+j and s = j*n+i in
				w.(r) <- v.(s)
			done
		done;
		w;;

(* line mixing (a special permutation)
mix 4 2 : 0,1,2,3, 4,5,6,7 -> 0,4, 1,5, 2,6, 3,7
unmix: inverse operation *)

let mix n p = perm (transpose n p (Array.init (n*p) (function x -> x)));;

let unmix n p = perm (transpose p n (Array.init (n*p) (function x -> x)));;

(* basic blocks

dummy:   no input, no output, usually not useful
const:   n wires with constant value (true or false)
encode:  translates an Int64 into boolean values, keeping only n lower bits
bnand:   NAND gate, the basic building block for all the other basic gates (or, and, not...) *)

let dummy = { nin=0; nout=0; apply=function
	bits -> bits };;

let const b n = { nin=0; nout=n; apply=function
	bits -> Array.make n b };;

let encode nbits x = { nin=0; nout=nbits; apply=function
	bits -> bits_of_int nbits x };;

let bnand = { nin=2; nout=1; apply=function
	[| a; b |] -> [| not (a && b) |] | _ -> failwith "bad args" };;

(* block evaluation : returns the value of the output, given an input and a block. *)

let eval block nbits_in nbits_out v =
	output nbits_out (block.apply (input nbits_in v));;

(* building a 4-bit adder *)

(* first we build the usual gates *)

let bnot = serial (fork 2) bnand;;

let band = serial bnand bnot;;

(* a or b = !a nand !b *)
let bor = serial (assoc bnot bnot) bnand;;

(* line "a" -> two lines, "a" and "not a" *)
let a_not_a = parallel (pass 1) bnot;;

let bxor = block_array serial [|
	assoc a_not_a a_not_a;
	perm [| 0; 3; 1; 2 |];
	assoc band band;
	bor |];;
	
let half_adder = parallel bxor band;;

(* bits C0,A,B -> S,C1 *)
let full_adder = block_array serial [|
	assoc half_adder (pass 1);
	perm [| 1; 0; 2 |];
	assoc (pass 1) half_adder;
	perm [| 1; 0; 2 |];
	assoc (pass 1) bor |];;

(* 4-bit adder *)
let add4 = block_array serial [|
	mix 4 2;
	assoc half_adder (pass 6);
	assoc (assoc (pass 1) full_adder) (pass 4);
	assoc (assoc (pass 2) full_adder) (pass 2);
	assoc (pass 3) full_adder |];;

(* 4-bit adder and three supplementary lines to make a multiple of 4 (to translate back to 4-bit integers) *)
let add4_io = assoc add4 (const false 3);;

(* wrapping the 4-bit to input and output integers instead of booleans
plus a b -> (sum,carry)
*)
let plus a b =
	let v = Array.map Int64.to_int
		(eval add4_io 4 4 (Array.map Int64.of_int [| a; b |])) in
	v.(0), v.(1);;
