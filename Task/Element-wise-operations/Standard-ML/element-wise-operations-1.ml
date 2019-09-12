structure Matrix = struct
local
    open Array2
    fun mapscalar f (x, scalar) =
	tabulate RowMajor (nRows x, nCols x, fn (i,j) => f(sub(x,i,j),scalar))
    fun map2 f (x, y) =
	tabulate RowMajor (nRows x, nCols x, fn (i,j) => f(sub(x,i,j),sub(y,i,j)))
in
infix splus sminus stimes
val op splus = mapscalar Int.+
val op sminus = mapscalar Int.-
val op stimes = mapscalar Int.*
val op + = map2 Int.+
val op - = map2 Int.-
val op * = map2 Int.*
val fromList = fromList
fun toList a =
    List.tabulate(nRows a, fn i => List.tabulate(nCols a, fn j => sub(a,i,j)))
end
end;

(* example *)
let open Matrix
    infix splus sminus stimes
    val m1 = fromList [[1,2],[3,4]]
    val m2 = fromList [[4,3],[2,1]]
    val s = 2			
in
    List.map toList [m1+m2, m1-m2, m1*m2,
		     m1 splus s, m1 sminus s, m1 stimes s]
end;
