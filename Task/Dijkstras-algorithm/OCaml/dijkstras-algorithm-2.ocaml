type vertex = int
type weight = float
type neighbor = vertex * weight
module VertexSet = Set.Make(struct type t = weight * vertex let compare = compare end)

let dijkstra (src:vertex) (adj_list:neighbor list array) : weight array * vertex array =
  let n = Array.length adj_list in
  let min_distance = Array.make n infinity in
  min_distance.(src) <- 0.;
  let previous = Array.make n (-1) in
  let rec aux vertex_queue =
    if not (VertexSet.is_empty vertex_queue) then
      let dist, u = VertexSet.min_elt vertex_queue in
      let vertex_queue' = VertexSet.remove (dist, u) vertex_queue in
      let edges = adj_list.(u) in
      let f vertex_queue (v, weight) =
        let dist_thru_u = dist +. weight in
        if dist_thru_u >= min_distance.(v) then
          vertex_queue
        else begin
          let vertex_queue' = VertexSet.remove (min_distance.(v), v) vertex_queue in
          min_distance.(v) <- dist_thru_u;
          previous.(v) <- u;
          VertexSet.add (min_distance.(v), v) vertex_queue'
        end
      in
      aux (List.fold_left f vertex_queue' edges)
  in
  aux (VertexSet.singleton (min_distance.(src), src));
  min_distance, previous

let shortest_path_to (target : vertex) (previous : vertex array) : vertex list =
  let rec aux target acc =
    if target = -1 then
      acc
    else
      aux previous.(target) (target :: acc)
  in
  aux target []

let adj_list =
  [| [(1, 7.); (2, 9.); (5, 14.)];           (* 0 = a *)
     [(0, 7.); (2, 10.); (3, 15.)];          (* 1 = b *)
     [(0, 9.); (1, 10.); (3, 11.); (5, 2.)]; (* 2 = c *)
     [(1, 15.); (2, 11.); (4, 6.)];          (* 3 = d *)
     [(3, 6.); (5, 9.)];                     (* 4 = e *)
     [(0, 14.); (2, 2.); (4, 9.)]            (* 5 = f *)
  |]

let () =
  let min_distance, previous = dijkstra 0 adj_list in
  Printf.printf "Distance from 0 to 4: %f\n" min_distance.(4);
  let path = shortest_path_to 4 previous in
  print_string "Path: ";
  List.iter (Printf.printf "%d, ") path;
  print_newline ()
