type point = { x: float; y : float; z : float }
let zero = { x = 0.0; y = 0.0; z = 0.0 }
let add a b = { x = a.x+.b.x; y = a.y+.b.y; z = a.z+.b.z }
let mul a k = { x = a.x*.k; y = a.y*.k; z= a.z*.k }
let div p k = mul p (1.0/.k)

type face = Face of point list
type edge = Edge of point*point

let make_edge a b = Edge (min a b, max a b)
let make_face a b c d = Face [a;b;c;d]

let centroid plist = div (List.fold_left add zero plist) (float (List.length plist))
let mid_edge (Edge (p1,p2)) = div (add p1 p2) 2.0
let face_point (Face pl) = centroid pl
let point_in_face p (Face pl) = List.mem p pl
let point_in_edge p (Edge (p1,p2)) = p = p1 || p = p2
let edge_in_face (Edge (p1,p2)) f = point_in_face p1 f && point_in_face p2 f

let border_edge faces e =
   List.length (List.filter (edge_in_face e) faces) < 2

let edge_point faces e =
   if border_edge faces e then mid_edge e else
   let adjacent = List.filter (edge_in_face e) faces in
   let fps = List.map face_point adjacent in
   centroid [mid_edge e; centroid fps]

let mod_vertex faces edges p =
   let v_edges = List.filter (point_in_edge p) edges in
   let v_faces = List.filter (point_in_face p) faces in
   let n = List.length v_faces in
   let is_border = n <> (List.length v_edges) in
   if is_border then
      let border_mids = List.map mid_edge (List.filter (border_edge faces) v_edges) in
      (* description ambiguity: average (border+p) or average(average(border),p) ?? *)
      centroid (p :: border_mids)
   else
      let avg_face = centroid (List.map face_point v_faces) in
      let avg_mid = centroid (List.map mid_edge v_edges) in
      div (add (add (mul p (float(n-3))) avg_face) (mul avg_mid 2.0)) (float n)

let edges_of_face (Face pl) =
   let rec next acc = function
      | [] -> invalid_arg "empty face"
      | a :: [] -> List.rev (make_edge a (List.hd pl) :: acc)
      | a :: (b :: _ as xs) -> next (make_edge a b :: acc) xs in
   next [] pl

let catmull_clark faces =
   let module EdgeSet = Set.Make(struct type t = edge let compare = compare end) in
   let edges = EdgeSet.elements (EdgeSet.of_list (List.concat (List.map edges_of_face faces))) in
   let mod_face ((Face pl) as face) =
      let fp = face_point face in
      let ep = List.map (edge_point faces) (edges_of_face face) in
      let e_tl = List.hd (List.rev ep) in
      let vl = List.map (mod_vertex faces edges) pl in
      let add_facet (e', acc) v e = e, (make_face e' v e fp :: acc) in
      let _, new_faces = List.fold_left2 add_facet (e_tl, []) vl ep in
      List.rev new_faces in
   List.concat (List.map mod_face faces)

let show_faces fl =
   let pr_point p = Printf.printf " (%.4f, %.4f, %.4f)" p.x p.y p.z in
   let pr_face (Face pl) = print_string "Face:"; List.iter pr_point pl; print_string "\n" in
   (print_string "surface {\n"; List.iter pr_face fl; print_string "}\n")

let c p q r = let s i = if i = 0 then -1.0 else 1.0 in { x = s p; y = s q; z = s r } ;;
let cube = [
   Face [c 0 0 0; c 0 0 1; c 0 1 1; c 0 1 0]; Face [c 1 0 0; c 1 0 1; c 1 1 1; c 1 1 0];
   Face [c 0 0 0; c 1 0 0; c 1 0 1; c 0 0 1]; Face [c 0 1 0; c 1 1 0; c 1 1 1; c 0 1 1];
   Face [c 0 0 0; c 0 1 0; c 1 1 0; c 1 0 0]; Face [c 0 0 1; c 0 1 1; c 1 1 1; c 1 0 1] ] in
show_faces cube;
show_faces (catmull_clark cube)
