let is_inside (x,y) ((ax,ay), (bx,by)) =
  (bx -. ax) *. (y -. ay) > (by -. ay) *. (x -. ax)

let intersection (sx,sy) (ex,ey) ((ax,ay), (bx,by)) =
  let dc_x, dc_y = (ax -. bx, ay -. by) in
  let dp_x, dp_y = (sx -. ex, sy -. ey) in
  let n1 = ax *. by -. ay *. bx in
  let n2 = sx *. ey -. sy *. ex in
  let n3 = 1.0 /. (dc_x *. dp_y -. dc_y *. dp_x) in
  ((n1 *. dp_x -. n2 *. dc_x) *. n3,
   (n1 *. dp_y -. n2 *. dc_y) *. n3)

let last lst = List.hd (List.rev lst)

let polygon_iter_edges poly f init =
  if poly = [] then init else
    let p0 = List.hd poly in
    let rec aux acc = function
      | p1 :: p2 :: tl -> aux (f (p1, p2) acc) (p2 :: tl)
      | p :: [] -> f (p, p0) acc
      | [] -> acc
    in
    aux init poly

let poly_clip subject_polygon clip_polygon =
  polygon_iter_edges clip_polygon (fun clip_edge input_list ->
    fst (
      List.fold_left (fun (out, s) e ->

        match (is_inside e clip_edge), (is_inside s clip_edge) with
        | true, false -> (e :: (intersection s e clip_edge) :: out), e
        | true, true -> (e :: out), e
        | false, true -> ((intersection s e clip_edge) :: out), e
        | false, false -> (out, e)

      ) ([], last input_list) input_list)

  ) subject_polygon

let () =
  let subject_polygon =
    [ ( 50.0, 150.0); (200.0,  50.0); (350.0, 150.0);
      (350.0, 300.0); (250.0, 300.0); (200.0, 250.0);
      (150.0, 350.0); (100.0, 250.0); (100.0, 200.0); ] in

  let clip_polygon =
    [ (100.0, 100.0); (300.0, 100.0); (300.0, 300.0); (100.0, 300.0) ] in

  List.iter (fun (x,y) ->
      Printf.printf " (%g, %g)\n" x y;
    ) (poly_clip subject_polygon clip_polygon)
