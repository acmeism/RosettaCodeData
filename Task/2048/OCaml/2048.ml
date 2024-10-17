let list_make x v =
  let rec aux acc i =
    if i <= 0 then acc else aux (v::acc) (i-1)
  in
  aux [] x


let pad_right n line =
  let len = List.length line in
  let x = n - len in
  line @ (list_make x 0)


let _move_left line =
  let n = List.length line in
  let line = List.filter ((<>) 0) line in
  let rec aux acc = function
  | x::y::tl ->
      if x = y
      then aux (x+y::acc) tl
      else aux (x::acc) (y::tl)
  | x::[] ->
      aux (x::acc) []
  | [] ->
      List.rev acc
  in
  pad_right n (aux [] line)


let move_left grid =
  List.map _move_left grid


let move_right grid =
  grid
    |> List.map List.rev
    |> List.map _move_left
    |> List.map List.rev


let rec replace g n v =
  match g with
  | x::xs -> if n = 0 then v::xs else x::(replace xs (n-1) v)
  | [] -> raise (Invalid_argument "replace")


(* add a new value in a random cell containing zero *)
let rec new_value grid =
  let zeros = ref [] in
  List.iteri (fun y line ->
    List.iteri (fun x v ->
      if v = 0 then zeros := (x, y) :: !zeros
    ) line;
  ) grid;
  let n = List.length !zeros in
  if n = 0 then raise Exit;
  let x, y = List.nth !zeros (Random.int n) in
  let v = if Random.int 10 = 0 then 4 else 2 in
  let line = List.nth grid y in
  let new_line = replace line x v in
  replace grid y new_line


(* turn counterclockwise *)
let turn_ccw grid =
  let y = List.length grid in
  let x = List.length (List.nth grid 0) in
  List.init x (fun i ->
    List.init y (fun j ->
      List.nth (List.nth grid j) (x-i-1)
    )
  )


(* turn clockwise *)
let turn_cw grid =
  let y = List.length grid in
  let x = List.length (List.nth grid 0) in
  List.init x (fun i ->
    List.init y (fun j ->
      List.nth (List.nth grid (y-j-1)) (i)
    )
  )


let move_up grid =
  grid
    |> turn_ccw
    |> move_left
    |> turn_cw


let move_down grid =
  grid
    |> turn_cw
    |> move_left
    |> turn_ccw


let display grid =
  List.iter (fun line ->
    print_string " [";
    line
      |> List.map (Printf.sprintf "%4d")
      |> String.concat "; "
      |> print_string;
    print_endline "]"
  ) grid


let () =
  Random.self_init ();
  let width =
    try int_of_string Sys.argv.(1)
    with _ -> 4
  in
  let line = list_make width 0 in
  let grid = list_make width line in

  let grid = new_value grid in
  let grid = new_value grid in

  print_endline {|
    s -> left
    f -> right
    e -> up
    d -> down
    q -> quit
  |};
  let rec loop grid =
    display grid;
    let grid =
      match read_line () with
      | "s" -> move_left grid
      | "f" -> move_right grid
      | "e" -> move_up grid
      | "d" -> move_down grid
      | "q" -> exit 0
      | _ -> grid
    in
    let grid =
      try new_value grid
      with Exit ->
        print_endline "Game Over";
        exit 0
    in
    loop grid
  in
  loop grid
