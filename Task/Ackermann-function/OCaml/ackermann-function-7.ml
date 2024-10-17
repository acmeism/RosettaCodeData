open Big_int
let one  = unit_big_int
let zero = zero_big_int
let succ = succ_big_int
let pred = pred_big_int
let add = add_big_int
let sub = sub_big_int
let eq = eq_big_int
let three = succ(succ one)
let power = power_int_positive_big_int

let eq2 (a1,a2) (b1,b2) =
  (eq a1 b1) && (eq a2 b2)

module H = Hashtbl.Make
  (struct
     type t = Big_int.big_int * Big_int.big_int
     let equal = eq2
     let hash (x,y) = Hashtbl.hash
       (Big_int.string_of_big_int x ^ "," ^
          Big_int.string_of_big_int y)
       (* probably not a very good hash function *)
   end)

let rec find_option h v =
  try Some (H.find h v)
  with Not_found -> None

let rec a bounds caller todo m n =
  let may_tail r =
    let k = (m,n) in
    match todo with
    | [] -> r
    | (m,n)::todo ->
        List.iter (fun k ->
                     if not (H.mem bounds k)
                     then H.add bounds k r) (k::caller);
        a bounds [] todo m n
  in
  match m, n with
  | m, n when eq m zero ->
      let r = (succ n) in
      may_tail r

  | m, n when eq n zero ->
      let caller = (m,n)::caller in
      a bounds caller todo (pred m) one

  | m, n when eq m three ->
      let r = sub (power 2 (add n three)) three in
      may_tail r

  | m, n ->
      match find_option bounds (m, pred n) with
      | Some a_rec ->
          let caller = (m,n)::caller in
          a bounds caller todo (pred m) a_rec
      | None ->
          let todo = (m,n)::todo in
          let caller = [(m, pred n)] in
          a bounds caller todo m (pred n)

let a = a (H.create 42 (* arbitrary *)) [] [] ;;

let () =
  let m, n =
    try
      big_int_of_string Sys.argv.(1),
      big_int_of_string Sys.argv.(2)
    with _ ->
      Printf.eprintf "usage: %s <int> <int>\n" Sys.argv.(0);
      exit 1
  in
  let r = a m n in
  Printf.printf "(a %s %s) = %s\n"
      (string_of_big_int m)
      (string_of_big_int n)
      (string_of_big_int r);
;;
