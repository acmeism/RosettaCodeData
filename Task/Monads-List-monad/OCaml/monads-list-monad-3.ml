let incr x = return (x+1)
let hex x = return (Format.sprintf "%#x" x)

(* Version 1 : With explicit calls *)
let () =
  let l = bind (bind (List.init 5 (fun x -> x)) incr) hex in
  print_str_list l

(* Version 2 : With >> operator *)
let () =
  let l = List.init 5 (fun x -> x) >> incr >> hex in
  print_str_list l

(* Version 3 : With let pruning *)
let () =
  let l =
    let* x = List.init 5 (fun x -> x) in
    let* y = incr x in hex y
  in print_str_list l
