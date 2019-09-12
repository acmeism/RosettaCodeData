structure Matrix = struct
local
    open Array2
    fun dot(x,y) = Vector.foldli (fn (i,xi,agg) => agg+xi*Vector.sub(y,i)) 0 x
in
val fromList = fromList
fun x*y = tabulate ColMajor (nRows x, nCols y, fn (i,j) => dot(row(x,i),column(y,j)))
(* for display *)
fun toList a =
    List.tabulate(nRows a, fn i => List.tabulate(nCols a, fn j => sub(a,i,j)))
end
end;
(* example *)
let open Matrix
    val m1 = fromList [[1,2],[3,4]]
    val m2 = fromList [[~3,~8,3],[~2,1,4]]
in
    toList (m1*m2)
end;
