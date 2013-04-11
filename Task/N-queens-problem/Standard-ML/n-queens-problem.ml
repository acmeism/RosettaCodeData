(*
 * val threat : (int * int) -> (int * int) -> bool
 * Returns true iff the queens at the given positions threaten each other
 *)
fun threat (x, y) (x', y') =
  x = x' orelse y = y' orelse abs(x - x') = abs(y - y');

(*
 * val conflict : (int * int) -> (int * int) list -> bool
 * Returns true if there exists a conflict with the position and the list of queens.
 *)
fun conflict pos = List.exists (threat pos);

(*
 * val addqueen : (int * int * (int * int) list * (unit -> (int * int) list option)) -> (int * int) list option
 * Returns either NONE in the case that no solution exists or SOME(l) where l is a list of positions making up the solution.
 *)
fun addqueen(i, n, qs, fc) =
  let
    fun try j =
      if j > n then fc()
      else if (conflict (i, j) qs) then try (j + 1)
      else if i = n then SOME((i, j)::qs)
      else addqueen(i + 1, n, (i,j)::qs, fn() => try (j + 1))
  in
    try 1
  end;

(*
 * val queens : int -> (int * int) list option
 * Given the board dimension n, returns a solution for the n-queens problem.
 *)
fun queens(n) = addqueen(1, n, [], fn () => NONE);

(* SOME [(8,4),(7,2),(6,7),(5,3),(4,6),(3,8),(2,5),(1,1)] *)
queens(8);

(* NONE *)
queens(2);
