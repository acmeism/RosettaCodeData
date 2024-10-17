(*
 * Convex hulls by Andrew's monotone chain algorithm.
 *
 * For a description of the algorithm, see
 * https://en.wikibooks.org/w/index.php?title=Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain&stableid=40169
 *)

(*------------------------------------------------------------------*)
(* Just enough plane geometry for our purpose.  *)

module Plane_point =
  struct
    type t = float * float

    let make (xy : t) = xy
    let to_tuple ((x, y) : t) = (x, y)

    let x ((x, _) : t) = x
    let y ((_, y) : t) = y

    let equal (u : t) (v : t) = (x u = x v && y u = y v)

    (* Impose a total order on points, making it one that will work
       for Andrew's monotone chain algorithm. *)
    let order (u : t) (v : t) =
      (x u < x v) || (x u = x v && y u < y v)

    (* The Array module's sort routines expect a "cmp" function. *)
    let cmp u v =
      if order u v then
        (-1)
      else if order v u then
        (1)
      else
        (0)

    (* Subtraction is really a vector or multivector operation. *)
    let sub (u : t) (v : t) = make (x u -. x v, y u -. y v)

    (* Cross product is really a multivector operation. *)
    let cross (u : t) (v : t) = (x u *. y v) -. (y u *. x v)

    let to_string ((x, y) : t) =
      "(" ^ string_of_float x ^ " " ^ string_of_float y ^ ")"
  end
;;

(*------------------------------------------------------------------*)
(* We want something akin to array_delete_neighbor_dups of Scheme's
   SRFI-132. *)

let array_delete_neighbor_dups equal arr =
  (* Returns a Seq.t rather than an array. *)
  let rec loop i lst =
    (* Cons a list of non-duplicates, going backwards through the
       array so the list will be in forwards order. *)
    if i = 0 then
      arr.(i) :: lst
    else if equal arr.(i - 1) arr.(i) then
      loop (i - 1) lst
    else
      loop (i - 1) (arr.(i) :: lst)
  in
  let n = Array.length arr in
  List.to_seq (if n = 0 then [] else loop (n - 1) [])
;;

(*------------------------------------------------------------------*)
(* The convex hull algorithm. *)

let cross_test pt_i hull j =
  let hull_j = hull.(j)
  and hull_j1 = hull.(j - 1) in
  0.0 < Plane_point.(cross (sub hull_j hull_j1)
                       (sub pt_i hull_j1))

let construct_lower_hull n pt =
  let hull = Array.make n (Plane_point.make (0.0, 0.0)) in
  let () = hull.(0) <- pt.(0)
  and () = hull.(1) <- pt.(1) in
  let rec outer_loop i j =
    if i = n then
      j + 1
    else
      let pt_i = pt.(i) in
      let rec inner_loop j =
        if j = 0 || cross_test pt_i hull j then
          begin
            hull.(j + 1) <- pt_i;
            j + 1
          end
        else
          inner_loop (j - 1)
      in
      outer_loop (i + 1) (inner_loop j)
  in
  let hull_size = outer_loop 2 1 in
  (hull_size, hull)

let construct_upper_hull n pt =
  let hull = Array.make n (Plane_point.make (0.0, 0.0)) in
  let () = hull.(0) <- pt.(n - 1)
  and () = hull.(1) <- pt.(n - 2) in
  let rec outer_loop i j =
    if i = (-1) then
      j + 1
    else
      let pt_i = pt.(i) in
      let rec inner_loop j =
        if j = 0 || cross_test pt_i hull j then
          begin
            hull.(j + 1) <- pt_i;
            j + 1
          end
        else
          inner_loop (j - 1)
      in
      outer_loop (i - 1) (inner_loop j)
  in
  let hull_size = outer_loop (n - 3) 1 in
  (hull_size, hull)

let construct_hull n pt =

  (* Side note: Construction of the lower and upper hulls can be done
     in parallel. *)
  let (lower_hull_size, lower_hull) = construct_lower_hull n pt
  and (upper_hull_size, upper_hull) = construct_upper_hull n pt in

  let hull_size = lower_hull_size + upper_hull_size - 2 in
  let hull = Array.make hull_size (Plane_point.make (0.0, 0.0)) in

  begin
    Array.blit lower_hull 0 hull 0 (lower_hull_size - 1);
    Array.blit upper_hull 0 hull (lower_hull_size - 1)
      (upper_hull_size - 1);
    hull
  end

let plane_convex_hull points =
  (* Takes an arbitrary sequence of points, which may be in any order
     and may contain duplicates. Returns an ordered array of points
     that make up the convex hull. If the sequence of points is empty,
     the returned array is empty. *)
  let pt = Array.of_seq points in
  let () = Array.fast_sort Plane_point.cmp pt in
  let pt = Array.of_seq
             (array_delete_neighbor_dups Plane_point.equal pt) in
  let n = Array.length pt in
  if n <= 2 then
    pt
  else
    construct_hull n pt
;;

(*------------------------------------------------------------------*)

let example_points =
  [Plane_point.make (16.0, 3.0);
   Plane_point.make (12.0, 17.0);
   Plane_point.make (0.0, 6.0);
   Plane_point.make (-4.0, -6.0);
   Plane_point.make (16.0, 6.0);
   Plane_point.make (16.0, -7.0);
   Plane_point.make (16.0, -3.0);
   Plane_point.make (17.0, -4.0);
   Plane_point.make (5.0, 19.0);
   Plane_point.make (19.0, -8.0);
   Plane_point.make (3.0, 16.0);
   Plane_point.make (12.0, 13.0);
   Plane_point.make (3.0, -4.0);
   Plane_point.make (17.0, 5.0);
   Plane_point.make (-3.0, 15.0);
   Plane_point.make (-3.0, -9.0);
   Plane_point.make (0.0, 11.0);
   Plane_point.make (-9.0, -3.0);
   Plane_point.make (-4.0, -2.0);
   Plane_point.make (12.0, 10.0)]
;;

let hull = plane_convex_hull (List.to_seq example_points)
;;

Array.iter
  (fun p -> (print_string (Plane_point.to_string p);
             print_string " "))
  hull;
print_newline ()
;;

(*------------------------------------------------------------------*)
