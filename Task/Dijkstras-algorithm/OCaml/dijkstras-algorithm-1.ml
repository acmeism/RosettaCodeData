let list_vertices graph =
  List.fold_left (fun acc ((a, b), _) ->
    let acc = if List.mem b acc then acc else b::acc in
    let acc = if List.mem a acc then acc else a::acc in
    acc
  ) [] graph

let neighbors v =
  List.fold_left (fun acc ((a, b), d) ->
    if a = v then (b, d)::acc else acc
  ) []

let remove_from v lst =
  let rec aux acc = function [] -> failwith "remove_from"
  | x::xs -> if x = v then List.rev_append acc xs else aux (x::acc) xs
  in aux [] lst

let with_smallest_distance q dist =
  match q with
  | [] -> assert false
  | x::xs ->
      let rec aux distance v = function
      | x::xs ->
          let d = Hashtbl.find dist x in
          if d < distance
          then aux d x xs
          else aux distance v xs
      | [] -> (v, distance)
      in
      aux (Hashtbl.find dist x) x xs

let dijkstra max_val zero add graph source target =
  let vertices = list_vertices graph in
  let dist_between u v =
    try List.assoc (u, v) graph
    with _ -> zero
  in
  let dist = Hashtbl.create 1 in
  let previous = Hashtbl.create 1 in
  List.iter (fun v ->                  (* initializations *)
    Hashtbl.add dist v max_val         (* unknown distance function from source to v *)
  ) vertices;
  Hashtbl.replace dist source zero;    (* distance from source to source *)
  let rec loop = function [] -> ()
  | q ->
      let u, dist_u =
        with_smallest_distance q dist in   (* vertex in q with smallest distance in dist *)
      if dist_u = max_val then
        failwith "vertices inaccessible";  (* all remaining vertices are inaccessible from source *)
      if u = target then () else begin
        let q = remove_from u q in
        List.iter (fun (v, d) ->
          if List.mem v q then begin
            let alt = add dist_u (dist_between u v) in
            let dist_v = Hashtbl.find dist v in
            if alt < dist_v then begin       (* relax (u,v,a) *)
              Hashtbl.replace dist v alt;
              Hashtbl.replace previous v u;  (* previous node in optimal path from source *)
            end
          end
        ) (neighbors u graph);
        loop q
      end
  in
  loop vertices;
  let s = ref [] in
  let u = ref target in
  while Hashtbl.mem previous !u do
    s := !u :: !s;
    u := Hashtbl.find previous !u
  done;
  (source :: !s)

let () =
  let graph =
    [ ("a", "b"), 7;
      ("a", "c"), 9;
      ("a", "f"), 14;
      ("b", "c"), 10;
      ("b", "d"), 15;
      ("c", "d"), 11;
      ("c", "f"), 2;
      ("d", "e"), 6;
      ("e", "f"), 9; ]
  in
  let p = dijkstra max_int 0 (+) graph "a" "e" in
  print_endline (String.concat " -> " p)
