(* identity matrix *)
let eye n =
  let a = Array.make_matrix n n 0.0 in
  for i=0 to n-1 do
    a.(i).(i) <- 1.0
  done;
  (a)
;;

(* matrix dimensions *)
let dim a = Array.length a, Array.length a.(0);;

(* make matrix from list in row-major order *)
let matrix p q v =
  if (List.length v) <> (p * q)
  then failwith "bad dimensions"
  else
    let a = Array.make_matrix p q (List.hd v) in
    let rec g i j = function
    | [] -> a
    | x::v ->
        a.(i).(j) <- x;
        if j+1 < q
        then g i (j+1) v
        else g (i+1) 0 v
    in
    g 0 0 v
;;

(* matrix product *)
let matmul a b =
  let n, p = dim a
  and q, r = dim b in
  if p <> q then failwith "bad dimensions" else
  let c = Array.make_matrix n r 0.0 in
  for i=0 to n-1 do
    for j=0 to r-1 do
      for k=0 to p-1 do
        c.(i).(j) <- c.(i).(j) +. a.(i).(k) *. b.(k).(j)
      done
    done
  done;
  (c)
;;

(* generic exponentiation, usual algorithm *)
let pow one mul a n =
  let rec g p x = function
  | 0 -> x
  | i ->
      g (mul p p) (if i mod 2 = 1 then mul p x else x) (i/2)
  in
  g a one n
;;

(* example with integers *)
pow 1 ( * ) 2 16;;
(* - : int = 65536 *)
