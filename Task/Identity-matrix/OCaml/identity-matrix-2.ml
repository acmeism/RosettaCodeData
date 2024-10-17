# let make_id_matrix n =
    Array.init n (fun i ->
      Array.init n (fun j ->
        if i = j then 1.0 else 0.0))
  ;;
val make_id_matrix : int -> float array array = <fun>

# make_id_matrix 4 ;;
- : float array array =
[| [|1.; 0.; 0.; 0.|];
   [|0.; 1.; 0.; 0.|];
   [|0.; 0.; 1.; 0.|];
   [|0.; 0.; 0.; 1.|] |]
