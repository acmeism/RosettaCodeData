open Dynar

let add3 (x1, y1, z1) (x2, y2, z2) (x3, y3, z3) =
  ( (x1 +. x2 +. x3),
    (y1 +. y2 +. y3),
    (z1 +. z2 +. z3) )

let mul m (x,y,z) = (m *. x, m *. y, m *. z)

let avg pts =
  let n, (x,y,z) =
    List.fold_left
      (fun (n, (xt,yt,zt)) (xi,yi,zi) ->
         succ n, (xt +. xi, yt +. yi, zt +. zi))
      (1, List.hd pts) (List.tl pts)
  in
  let n = float_of_int n in
  (x /. n, y /. n, z /. n)


let catmull ~points ~faces =
  let da_points = Dynar.of_array points in
  let new_faces = Dynar.of_array [| |] in
  let push_face face = Dynar.push new_faces face in
  let h1 = Hashtbl.create 43 in
  let h2 = Hashtbl.create 43 in
  let h3 = Hashtbl.create 43 in
  let h4 = Hashtbl.create 43 in
  let blg = Array.make (Array.length points) 0 in (* how many faces a point belongs to *)
  let f_incr p = blg.(p) <- succ blg.(p) in
  let eblg = Array.make (Array.length points) 0 in (* how many edges a point belongs to *)
  let e_incr p = eblg.(p) <- succ eblg.(p) in
  let edge a b = (min a b, max a b) in  (* suitable for hash-table keys *)
  let mid_edge p1 p2 =
    let x1, y1, z1 = points.(p1)
    and x2, y2, z2 = points.(p2) in
    ( (x1 +. x2) /. 2.0,
      (y1 +. y2) /. 2.0,
      (z1 +. z2) /. 2.0 )
  in
  let mid_face p1 p2 p3 p4 =
    let x1, y1, z1 = points.(p1)
    and x2, y2, z2 = points.(p2)
    and x3, y3, z3 = points.(p3)
    and x4, y4, z4 = points.(p4) in
    ( (x1 +. x2 +. x3 +. x4) /. 4.0,
      (y1 +. y2 +. y3 +. y4) /. 4.0,
      (z1 +. z2 +. z3 +. z4) /. 4.0 )
  in
  Array.iteri (fun i (a,b,c,d) ->
    f_incr a; f_incr b; f_incr c; f_incr d;

    let face_point = mid_face a b c d in
    let face_pi = pushi da_points face_point in
    Hashtbl.add h3 a face_point;
    Hashtbl.add h3 b face_point;
    Hashtbl.add h3 c face_point;
    Hashtbl.add h3 d face_point;

    let process_edge a b =
      let ab = edge a b in
      if not(Hashtbl.mem h1 ab)
      then begin
        let mid_ab = mid_edge a b in
        let index = pushi da_points mid_ab in
        Hashtbl.add h1 ab (index, mid_ab, [face_point]);
        Hashtbl.add h2 a mid_ab;
        Hashtbl.add h2 b mid_ab;
        Hashtbl.add h4 mid_ab 1;
        (index)
      end
      else begin
        let index, mid_ab, fpl = Hashtbl.find h1 ab in
        Hashtbl.replace h1 ab (index, mid_ab, face_point::fpl);
        Hashtbl.add h4 mid_ab (succ(Hashtbl.find h4 mid_ab));
        (index)
      end
    in
    let mid_ab = process_edge a b
    and mid_bc = process_edge b c
    and mid_cd = process_edge c d
    and mid_da = process_edge d a in

    push_face (a, mid_ab, face_pi, mid_da);
    push_face (b, mid_bc, face_pi, mid_ab);
    push_face (c, mid_cd, face_pi, mid_bc);
    push_face (d, mid_da, face_pi, mid_cd);
  ) faces;

  Hashtbl.iter (fun (a,b) (index, mid_ab, fpl) ->
    e_incr a; e_incr b;
    if List.length fpl = 2 then
      da_points.ar.(index) <- avg (mid_ab::fpl)
  ) h1;

  Array.iteri (fun i old_vertex ->
    let n = blg.(i)
    and e_n = eblg.(i) in
    (* if the vertex doesn't belongs to as many faces than edges
       this means that this is a hole *)
    if n = e_n then
    begin
      let avg_face_points =
        let face_point_list = Hashtbl.find_all h3 i in
        (avg face_point_list)
      in
      let avg_mid_edges =
        let mid_edge_list = Hashtbl.find_all h2 i in
        (avg mid_edge_list)
      in
      let n = float_of_int n in
      let m1 = (n -. 3.0) /. n
      and m2 = 1.0 /. n
      and m3 = 2.0 /. n in
      da_points.ar.(i) <-
          add3 (mul m1 old_vertex)
               (mul m2 avg_face_points)
               (mul m3 avg_mid_edges)
    end
    else begin
      let mid_edge_list = Hashtbl.find_all h2 i in
      let mid_edge_list =
        (* only average mid-edges near the hole *)
        List.fold_left (fun acc mid_edge ->
          match Hashtbl.find h4 mid_edge with
          | 1 -> mid_edge::acc
          | _ -> acc
        ) [] mid_edge_list
      in
      da_points.ar.(i) <- avg (old_vertex :: mid_edge_list)
    end
  ) points;

  (Dynar.to_array da_points,
   Dynar.to_array new_faces)
;;
