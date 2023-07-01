let fmt_linear_comb =
  let rec head e = function
    | 0 :: t -> head (succ e) t
    | 1 :: t -> Printf.sprintf "e(%u)%s" e (tail (succ e) t)
    | -1 :: t -> Printf.sprintf "-e(%u)%s" e (tail (succ e) t)
    | a :: t -> Printf.sprintf "%d*e(%u)%s" a e (tail (succ e) t)
    | _ -> "0"
  and tail e = function
    | 0 :: t -> tail (succ e) t
    | 1 :: t -> Printf.sprintf " + e(%u)%s" e (tail (succ e) t)
    | -1 :: t -> Printf.sprintf " - e(%u)%s" e (tail (succ e) t)
    | a :: t when a < 0 -> Printf.sprintf " - %u*e(%u)%s" (-a) e (tail (succ e) t)
    | a :: t -> Printf.sprintf " + %u*e(%u)%s" a e (tail (succ e) t)
    | _ -> ""
  in
  head 1

let () =
  List.iter (fun v -> print_endline (fmt_linear_comb v)) [
    [1; 2; 3];
    [0; 1; 2; 3];
    [1; 0; 3; 4];
    [1; 2; 0];
    [0; 0; 0];
    [0];
    [1; 1; 1];
    [-1; -1; -1];
    [-1; -2; 0; -3];
    [-1]]
