let safe_div x y = if y = 0.0 then None else return (x /. y)
let safe_root x = if x < 0.0 then None else return (sqrt x)
let safe_str x = return (Format.sprintf "%#f" x)

(* Version 1 : explicit calls *)
let () =
  let v = bind (bind (safe_div 5. 3.) safe_root) safe_str in
  print_str_opt v

(* Version 2 : with an operator *)
let () =
  let v = safe_div 5. 3. --> safe_root --> safe_str in
  print_str_opt v

(* Version 3 : let pruning really shine when inlining functions *)
let () =
  let v =
    let* x = safe_div 5. 3. in
    let* y = if x < 0.0 then None else return (sqrt x) in
    return (Format.sprintf "%#f" y)
  in print_str_opt v
