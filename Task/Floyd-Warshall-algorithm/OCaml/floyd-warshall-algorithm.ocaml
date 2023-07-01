(*
  Floyd-Warshall algorithm.

  See https://en.wikipedia.org/w/index.php?title=Floyd%E2%80%93Warshall_algorithm&oldid=1082310013
 *)

module Square_array =

  (* Square arrays with 1-based indexing. *)

  struct
    type 'a t =
      {
        n : int;
        r : 'a Array.t
      }

    let make n fill =
      let r = Array.make (n * n) fill in
      { n = n; r = r }

    let get arr (i, j) =
      Array.get arr.r ((i - 1) + (arr.n * (j - 1)))

    let set arr (i, j) x =
      Array.set arr.r ((i - 1) + (arr.n * (j - 1))) x
  end

module Vertex =

  (* A vertex is a positive integer, or 0 for the nil object. *)

  struct
    type t = int

    let nil = 0

    let print_vertex u =
      print_int u

    let rec print_directed_list lst =
      match lst with
      | [] -> ()
      | [u] -> print_vertex u
      | u :: tail ->
         begin
           print_vertex u;
           print_string " -> ";
           print_directed_list tail
         end
  end

module Edge =

  (* A graph edge. *)

  struct
    type t =
      {
        u : Vertex.t;
        weight : Float.t;
        v : Vertex.t
      }

    let make u weight v =
      { u = u; weight = weight; v = v }
  end

module Paths =

  (* The "next vertex" array and its operations. *)

  struct
    type t = Vertex.t Square_array.t

    let make n =
      Square_array.make n Vertex.nil

    let get = Square_array.get
    let set = Square_array.set

    let path paths u v =
      (* Path reconstruction. In the finest tradition of the standard
         List module, this implementation is *not* tail recursive. *)
      if Square_array.get paths (u, v) = Vertex.nil then
        []
      else
        let rec build_path paths u v =
          if u = v then
            [v]
          else
            let i = Square_array.get paths (u, v) in
            u :: build_path paths i v
        in
        build_path paths u v

    let print_path paths u v =
      Vertex.print_directed_list (path paths u v)
  end

module Distances =

  (* The "distance" array and its operations. *)

  struct
    type t = Float.t Square_array.t

    let make n =
      Square_array.make n Float.infinity

    let get = Square_array.get
    let set = Square_array.set
  end

let find_max_vertex edges =
  (* This implementation is *not* tail recursive. *)
  let rec find_max =
    function
    | [] -> Vertex.nil
    | edge :: tail -> max (max Edge.(edge.u) Edge.(edge.v))
                        (find_max tail)
  in
  find_max edges

let floyd_warshall edges =
  (* This implementation assumes IEEE floating point. The OCaml Float
     module explicitly specifies 64-bit IEEE floating point. *)
  let _ = assert (edges <> []) in
  let n = find_max_vertex edges in
  let dist = Distances.make n in
  let next = Paths.make n in
  let rec read_edges =
    function
    | [] -> ()
    | edge :: tail ->
       let u = Edge.(edge.u) in
       let v = Edge.(edge.v) in
       let weight = Edge.(edge.weight) in
       begin
         Distances.set dist (u, v) weight;
         Paths.set next (u, v) v;
         read_edges tail
       end
  in
  begin

    (* Initialization. *)

    read_edges edges;
    for i = 1 to n do
      (* Distance from a vertex to itself = 0.0 *)
      Distances.set dist (i, i) 0.0;
      Paths.set next (i, i) i
    done;

    (* Perform the algorithm. *)

    for k = 1 to n do
      for i = 1 to n do
        for j = 1 to n do
          let dist_ij = Distances.get dist (i, j) in
          let dist_ik = Distances.get dist (i, k) in
          let dist_kj = Distances.get dist (k, j) in
          let dist_ikj = dist_ik +. dist_kj in
          if dist_ikj < dist_ij then
            begin
              Distances.set dist (i, j) dist_ikj;
              Paths.set next (i, j) (Paths.get next (i, k))
            end
        done
      done
    done;

    (* Return the results, as a 3-tuple. *)

    (n, dist, next)

  end

let example_graph =
  [Edge.make 1 (-2.0) 3;
   Edge.make 3 (+2.0) 4;
   Edge.make 4 (-1.0) 2;
   Edge.make 2 (+4.0) 1;
   Edge.make 2 (+3.0) 3]
;;

let (n, dist, next) =
  floyd_warshall example_graph
;;

print_string "  pair     distance    path";
print_newline ();
print_string "---------------------------------------";
print_newline ();
for u = 1 to n do
  for v = 1 to n do
    if u <> v then
      begin
        print_string " ";
        Vertex.print_directed_list [u; v];
        print_string "     ";
        Printf.printf "%4.1f" (Distances.get dist (u, v));
        print_string "      ";
        Paths.print_path next u v;
        print_newline ()
      end
  done
done
;;
