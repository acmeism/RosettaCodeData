$ ocaml

# let make_id_matrix n =
    let m = Array.make_matrix n n 0.0 in
    for i = 0 to pred n do
      m.(i).(i) <- 1.0
    done;
    (m)
  ;;
val make_id_matrix : int -> float array array = <fun>

# make_id_matrix 4 ;;
- : float array array =
[| [|1.; 0.; 0.; 0.|];
   [|0.; 1.; 0.; 0.|];
   [|0.; 0.; 1.; 0.|];
   [|0.; 0.; 0.; 1.|] |]
