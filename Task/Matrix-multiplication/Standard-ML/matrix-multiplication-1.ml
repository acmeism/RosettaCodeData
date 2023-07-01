structure IMatrix = struct
fun dot(x,y) = Vector.foldli (fn (i,xi,agg) => agg+xi*Vector.sub(y,i)) 0 x
fun x*y =
    let
	open Array2
    in
	tabulate ColMajor (nRows x, nCols y, fn (i,j) => dot(row(x,i),column(y,j)))
    end
end;
(* for display *)
fun toList a =
    let
	open Array2
    in
	List.tabulate(nRows a,  fn i => List.tabulate(nCols a, fn j => sub(a,i,j)))
    end;
(* example *)
let
    open IMatrix
    val m1 = Array2.fromList [[1,2],[3,4]]
    val m2 = Array2.fromList [[~3,~8,3],[~2,1,4]]
in
    toList (m1*m2)
end;
