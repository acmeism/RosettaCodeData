(* Version 1 : with explicit calls *)
let pythegorean_triple n =
  let x = List.init n (fun x -> x) in
  let y = List.init n (fun x -> x) in
  let z = List.init n (fun x -> x) in
  bind x (fun x ->
    bind y (fun y ->
      bind z (fun z ->
        if x*x + y*y = z*z then return (x,y,z) else []
  )))

(* Version 2 : with >> operator *)
let pythegorean_triple n =
  List.init n (fun x -> x) >> fun x ->
    List.init n (fun x -> x) >> fun y ->
      List.init n (fun x -> x) >> fun z ->
        if x*x + y*y = z*z then return (x,y,z) else []

(* Version 3 : with let pruning *)
let pythegorean_triple n =
  let* x = List.init n (fun x -> x) in
  let* y = List.init n (fun x -> x) in
  let* z = List.init n (fun x -> x) in
  if x*x + y*y = z*z then return (x,y,z) else []
