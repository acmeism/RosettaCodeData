let matpow a n =
  let p, q = dim a in
  if p <> q then failwith "bad dimensions" else
  pow (eye p) matmul a n;;

matpow (matrix 2 2 [ 1.0; 1.0; 1.0; 0.0 ]) 10;;
(* - : float array array = [|[|89.; 55.|]; [|55.; 34.|]|] *)

(* use as infix operator *)
let ( ^^ ) = matpow;;

[| [| 1.0; 1.0|]; [| 1.0; 0.0 |] |] ^^ 10;;
(* - : float array array = [|[|89.; 55.|]; [|55.; 34.|]|] *)
