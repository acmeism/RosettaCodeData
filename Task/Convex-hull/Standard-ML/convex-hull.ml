(*
 * Convex hulls by Andrew's monotone chain algorithm.
 *
 * For a description of the algorithm, see
 * https://en.wikibooks.org/w/index.php?title=Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain&stableid=40169
 *)

(*------------------------------------------------------------------*)
(*
 * Just enough plane geometry for our purpose.
 *)

signature PLANE_POINT =
sig
  type planePoint
  val planePoint : real * real -> planePoint
  val toTuple : planePoint -> real * real
  val x : planePoint -> real
  val y : planePoint -> real
  val == : planePoint * planePoint -> bool

  (* Impose a total order on points, making it one that will work for
     Andrew's monotone chain algorithm. *)
  val order : planePoint * planePoint -> bool

  (* Subtraction is really a vector or multivector operation. *)
  val subtract : planePoint * planePoint -> planePoint

  (* Cross product is really a multivector operation. *)
  val cross : planePoint * planePoint -> real

  val toString : planePoint -> string
end

structure PlanePoint : PLANE_POINT =
struct
type planePoint = real * real

fun planePoint xy = xy
fun toTuple (x, y) = (x, y)
fun x (x, _) = x
fun y (_, y) = y

fun == ((a : real, b : real), (c : real, d : real)) =
    Real.== (a, c) andalso Real.== (b, d)

fun order ((a : real, b : real), (c : real, d : real)) =
    Real.< (a, c) orelse (Real.== (a, c) andalso Real.< (b, d))

fun subtract ((a : real, b : real), (c : real, d : real)) =
    (a - c, b - d)

fun cross ((a : real, b : real), (c : real, d : real)) =
    (a * d) - (b * c)

fun toString (x, y) =
    "(" ^ Real.toString x ^ " " ^ Real.toString y ^ ")"
end

(*------------------------------------------------------------------*)
(*
 * Rather than rely on compiler extensions for sorting, let us write
 * our own.
 *
 * For no special reason, let us use the Shell sort of
 * https://en.wikipedia.org/w/index.php?title=Shellsort&oldid=1084744510
 *)

val ciura_gaps = Array.fromList [701, 301, 132, 57, 23, 10, 4, 1]

fun sort_in_place less arr =
    let
      open Array

      fun span_gap gap =
          let
            fun iloop i =
                if length arr <= i then
                  ()
                else
                  let
                    val temp = sub (arr, i)
                    fun jloop j =
                        if j < gap orelse
                           less (sub (arr, j - gap), temp) then
                          update (arr, j, temp)
                        else
                          (update (arr, j, sub (arr, j - gap));
                           jloop (j - gap))
                  in
                    jloop i;
                    iloop (i + gap)
                  end
          in
            iloop 0
          end
    in
      app span_gap ciura_gaps
    end

(*------------------------------------------------------------------*)
(*
 * To go with our sort routine, we want something akin to
 * array_delete_neighbor_dups of Scheme's SRFI-132.
 *)

fun array_delete_neighbor_dups equal arr =
    let
      open Array

      fun loop i lst =
          (* Cons a list of non-duplicates, going backwards through
             the array so the list will be in forwards order. *)
          if i = 0 then
            sub (arr, i) :: lst
          else if equal (sub (arr, i - 1), sub (arr, i)) then
            loop (i - 1) lst
          else
            loop (i - 1) (sub (arr, i) :: lst)

      val n = length arr
    in
      fromList (if n = 0 then [] else loop (n - 1) [])
    end

(*------------------------------------------------------------------*)
(*
 * The convex hull algorithm.
 *)

fun cross_test (pt_i, hull, j) =
    let
      open PlanePoint
      val hull_j = Array.sub (hull, j)
      val hull_j1 = Array.sub (hull, j - 1)
    in
      0.0 < cross (subtract (hull_j, hull_j1),
                   subtract (pt_i, hull_j1))
    end

fun construct_lower_hull (n, pt) =
    let
      open PlanePoint

      val hull = Array.array (n, planePoint (0.0, 0.0))
      val () = Array.update (hull, 0, Array.sub (pt, 0))
      val () = Array.update (hull, 1, Array.sub (pt, 1))

      fun outer_loop i j =
          if i = n then
            j + 1
          else
            let
              val pt_i = Array.sub (pt, i)

              fun inner_loop j =
                  if j = 0 orelse cross_test (pt_i, hull, j) then
                    (Array.update (hull, j + 1, pt_i);
                     j + 1)
                  else
                    inner_loop (j - 1)
            in
              outer_loop (i + 1) (inner_loop j)
            end

      val hull_size = outer_loop 2 1
    in
      (hull_size, hull)
    end

fun construct_upper_hull (n, pt) =
    let
      open PlanePoint

      val hull = Array.array (n, planePoint (0.0, 0.0))
      val () = Array.update (hull, 0, Array.sub (pt, n - 1))
      val () = Array.update (hull, 1, Array.sub (pt, n - 2))

      fun outer_loop i j =
          if i = ~1 then
            j + 1
          else
            let
              val pt_i = Array.sub (pt, i)

              fun inner_loop j =
                  if j = 0 orelse cross_test (pt_i, hull, j) then
                    (Array.update (hull, j + 1, pt_i);
                     j + 1)
                  else
                    inner_loop (j - 1)
            in
              outer_loop (i - 1) (inner_loop j)
            end

      val hull_size = outer_loop (n - 3) 1
    in
      (hull_size, hull)
    end

fun construct_hull (n, pt) =
    let
      (* Side note: Construction of the lower and upper hulls can be
         done in parallel. *)
      val (lower_hull_size, lower_hull) = construct_lower_hull (n, pt)
      and (upper_hull_size, upper_hull) = construct_upper_hull (n, pt)

      val hull_size = lower_hull_size + upper_hull_size - 2
      val hull =
          Array.array (hull_size, PlanePoint.planePoint (0.0, 0.0))

      fun copy_lower i =
          if i = lower_hull_size - 1 then
            ()
          else
            (Array.update (hull, i, Array.sub (lower_hull, i));
             copy_lower (i + 1))

      fun copy_upper i =
          if i = upper_hull_size - 1 then
            ()
          else
            (Array.update (hull, i + lower_hull_size - 1,
                           Array.sub (upper_hull, i));
             copy_upper (i + 1))
    in
      copy_lower 0;
      copy_upper 0;
      hull
    end

fun plane_convex_hull points_lst =
    (* Takes an arbitrary list of points, which may be in any order
       and may contain duplicates. Returns an ordered array of points
       that make up the convex hull. If the list of points is empty,
       the returned array is empty. *)
    let
      val pt = Array.fromList points_lst
      val () = sort_in_place PlanePoint.order pt
      val pt = array_delete_neighbor_dups (PlanePoint.==) pt
      val n = Array.length pt
    in
      if n <= 2 then
        pt
      else
        construct_hull (n, pt)
    end

(*------------------------------------------------------------------*)

fun main () =
    let
      open PlanePoint

      val example_points =
          [planePoint (16.0, 3.0),
           planePoint (12.0, 17.0),
           planePoint (0.0, 6.0),
           planePoint (~4.0, ~6.0),
           planePoint (16.0, 6.0),
           planePoint (16.0, ~7.0),
           planePoint (16.0, ~3.0),
           planePoint (17.0, ~4.0),
           planePoint (5.0, 19.0),
           planePoint (19.0, ~8.0),
           planePoint (3.0, 16.0),
           planePoint (12.0, 13.0),
           planePoint (3.0, ~4.0),
           planePoint (17.0, 5.0),
           planePoint (~3.0, 15.0),
           planePoint (~3.0, ~9.0),
           planePoint (0.0, 11.0),
           planePoint (~9.0, ~3.0),
           planePoint (~4.0, ~2.0),
           planePoint (12.0, 10.0)]

      val hull = plane_convex_hull example_points
    in
      Array.app (fn p => (print (toString p);
                          print " "))
                hull;
      print "\n"
    end;

main ();

(*------------------------------------------------------------------*)
(* local variables: *)
(* mode: sml *)
(* sml-indent-level: 2 *)
(* sml-indent-args: 2 *)
(* end: *)
