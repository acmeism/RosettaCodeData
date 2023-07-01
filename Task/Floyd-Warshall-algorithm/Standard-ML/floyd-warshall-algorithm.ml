(*
  Floyd-Warshall algorithm.

  See https://en.wikipedia.org/w/index.php?title=Floyd%E2%80%93Warshall_algorithm&oldid=1082310013
 *)

(*------------------------------------------------------------------(*

   In this program, I introduce more "abstraction" than there was in
   earlier versions, which were written in the SML-like languages
   OCaml and ATS. This is an example of proceeding from where one has
   gotten so far, to turn a program into a better one. The
   improvements made here could be backported to the other languages.

   In most respects, though, this program is very similar to the
   OCaml.

   Standard ML seems to specify its REAL signature is for IEEE
   floating point, so this program assumes there is a positive
   "infinity". (The difference is tiny between an algorithm with
   "infinity" and one without.)

*)------------------------------------------------------------------*)

(* Square arrays with 1-based indexing. *)

signature SQUARE_ARRAY =
sig
  type 'a squareArray
  val make : int * 'a -> 'a squareArray
  val get : 'a squareArray -> int * int -> 'a
  val set : 'a squareArray -> int * int -> 'a -> unit
end

structure SquareArray : SQUARE_ARRAY =
struct

type 'a squareArray = int * 'a array

fun make (n, fill) =
    (n, Array.array (n * n, fill))

fun get (n, r) (i, j) =
    Array.sub (r, (i - 1) + (n * (j - 1)))

fun set (n, r) (i, j) x =
    Array.update (r, (i - 1) + (n * (j - 1)), x)

end

(*------------------------------------------------------------------*)

(* A vertex is, internally, a positive integer, or 0 for the nil
   object. *)

signature VERTEX =
sig
  exception VertexError
  eqtype vertex
  val nilVertex : vertex
  val isNil : vertex -> bool
  val max : vertex * vertex -> vertex
  val toInt : vertex -> int
  val fromInt : int -> vertex
  val toString : vertex -> string
  val directedListToString : vertex list -> string
end

structure Vertex : VERTEX =
struct

exception VertexError

type vertex = int

val nilVertex = 0

fun isNil u = u = nilVertex
fun max (u, v) = Int.max (u, v)
fun toInt u = u

fun fromInt i =
    if i < nilVertex then
      raise VertexError
    else
      i

fun toString u = Int.toString u

fun directedListToString [] = ""
  | directedListToString [u] = toString u
  | directedListToString (u :: tail) =
    (* This implementation is *not* tail recursive. *)
    (toString u) ^ " -> " ^ (directedListToString tail)

end

(*------------------------------------------------------------------*)

(* Graph edges, with weights. *)

signature EDGE =
sig
  type edge
  val make : Vertex.vertex * real * Vertex.vertex -> edge
  val first : edge -> Vertex.vertex
  val weight : edge -> real
  val second : edge -> Vertex.vertex
end

structure Edge : EDGE =
struct

type edge = Vertex.vertex * real * Vertex.vertex

fun make edge = edge
fun first (u, _, _) = u
fun weight (_, w, _) = w
fun second (_, _, v) = v

end

(*------------------------------------------------------------------*)

(* The "dist" array and its operations. *)

signature DISTANCES =
sig
  type distances
  val make : int -> distances
  val get : distances -> int * int -> real
  val set : distances -> int * int -> real -> unit
end

structure Distances : DISTANCES =
struct

type distances = real SquareArray.squareArray

fun make n = SquareArray.make (n, Real.posInf)
val get = SquareArray.get
val set = SquareArray.set

end

(*------------------------------------------------------------------*)

(* The "next" array and its operations. It lets you look up optimum
   paths. *)

signature PATHS =
sig
  type paths
  val make : int -> paths
  val get : paths -> int * int -> Vertex.vertex
  val set : paths -> int * int -> Vertex.vertex -> unit
  val path : (paths * int * int) -> Vertex.vertex list
  val pathString : (paths * int * int) -> string
end

structure Paths : PATHS =
struct

type paths = Vertex.vertex SquareArray.squareArray

fun make n = SquareArray.make (n, Vertex.nilVertex)
val get = SquareArray.get
val set = SquareArray.set

fun path (p, u, v) =
    if Vertex.isNil (get p (u, v)) then
      []
    else
      let
        fun
        build_path (p, u, v) =
        if u = v then
          [v]
        else
          let
            val i = get p (u, v)
          in
            u :: build_path (p, i, v)
          end
      in
        build_path (p, u, v)
      end

fun pathString (p, u, v) =
    Vertex.directedListToString (path (p, u, v))

end

(*------------------------------------------------------------------*)

(* Floyd-Warshall. *)

exception FloydWarshallError

fun find_max_vertex [] = Vertex.nilVertex
  | find_max_vertex (edge :: tail) =
    (* This implementation is *not* tail recursive. *)
    Vertex.max (Vertex.max (Edge.first edge, Edge.second edge),
                find_max_vertex tail)

fun floyd_warshall [] = raise FloydWarshallError
  | floyd_warshall edges =
    let
      val n = find_max_vertex edges
      val dist = Distances.make n
      val next = Paths.make n

      fun read_edges [] = ()
        | read_edges (edge :: tail) =
          let
            val u = Edge.first edge
            val v = Edge.second edge
            val weight = Edge.weight edge
          in
            (Distances.set dist (u, v) weight;
             Paths.set next (u, v) v;
             read_edges tail)
          end

      val indices =
          (* Indices in order from 1 .. n. *)
          List.tabulate (n, fn i => i + 1)
    in

      (* Initialization. *)

      read_edges edges;
      List.app (fn i => (Distances.set dist (i, i) 0.0;
                         Paths.set next (i, i) i))
               indices;

      (* Perform the algorithm. *)

      List.app
        (fn k =>
            List.app
              (fn i =>
                  List.app
                    (fn j =>
                        let
                          val dist_ij = Distances.get dist (i, j)
                          val dist_ik = Distances.get dist (i, k)
                          val dist_kj = Distances.get dist (k, j)
                          val dist_ikj = dist_ik + dist_kj
                        in
                          if dist_ikj < dist_ij then
                            let
                              val new_dist = dist_ikj
                              val new_next = Paths.get next (i, k)
                            in
                              Distances.set dist (i, j) new_dist;
                              Paths.set next (i, j) new_next
                            end
                          else
                            ()
                        end)
                    indices)
              indices)
        indices;

      (* Return the results, as a 3-tuple. *)

      (n, dist, next)

    end

(*------------------------------------------------------------------*)

fun tilde_to_minus s =
    String.translate (fn c => if c = #"~" then "-" else str c) s

fun main () =
    let
      val example_graph =
          [Edge.make (Vertex.fromInt 1, ~2.0, Vertex.fromInt 3),
           Edge.make (Vertex.fromInt 3, 2.0, Vertex.fromInt 4),
           Edge.make (Vertex.fromInt 4, ~1.0, Vertex.fromInt 2),
           Edge.make (Vertex.fromInt 2, 4.0, Vertex.fromInt 1),
           Edge.make (Vertex.fromInt 2, 3.0, Vertex.fromInt 3)]

      val (n, dist, next) = floyd_warshall example_graph

      val indices =
          (* Indices in order from 1 .. n. *)
          List.tabulate (n, fn i => i + 1)
    in
      print "  pair     distance    path\n";
      print "---------------------------------------\n";
      List.app
        (fn u =>
            List.app
              (fn v =>
                  if u <> v then
                    (print " ";
                     print (Vertex.directedListToString [u, v]);
                     print "     ";
                     if 0.0 <= Distances.get dist (u, v) then
                       print " "
                     else
                       ();
                     print (tilde_to_minus
                              (Real.fmt (StringCvt.FIX (SOME 1))
                                        (Distances.get dist (u, v))));
                     print "      ";
                     print (Paths.pathString (next, u, v));
                     print "\n")
                  else
                    ())
              indices)
        indices
    end;

(* Comment out the following line, if you are using Poly/ML. *)
main ();

(*------------------------------------------------------------------*)
(* local variables: *)
(* mode: sml *)
(* sml-indent-level: 2 *)
(* sml-indent-args: 2 *)
(* end: *)
