signature RADCATFIELD = sig
type real
val zero : real
val one : real
val + : real * real -> real
val - : real * real -> real
val * : real * real -> real
val / : real * real -> real
val sign : real -> real
val sqrt : real -> real
end
		
functor QR(F: RADCATFIELD) = struct
structure A = struct
local
    open Array
in
fun unitVector n = tabulate (n, fn i => if i=0 then F.one else F.zero)
fun map f x = tabulate(length x, fn i => f(sub(x,i)))
fun map2 f (x, y) = tabulate(length x, fn i => f(sub(x,i),sub(y,i)))
val op + = map2 F.+
val op - = map2 F.-
val op * = map2 F.*
fun multc(c,x) = array(length x,c)*x
fun dot (x,y) = foldl F.+ F.zero (x*y)
fun outer f (x,y) =
    Array2.tabulate Array2.RowMajor (length x, length y,
				     fn (i,j) => f(sub(x,i),sub(y,j)))
fun copy x = map (fn x => x) x
fun fromVector v = tabulate(Vector.length v, fn i => Vector.sub(v,i))
fun slice(x,i,sz) =
    let	open ArraySlice
	val s = slice(x,i,sz)
    in Array.tabulate(length s, fn i => sub(s,i)) end
end
end
structure M = struct
local
    open Array2
in
fun map f x = tabulate RowMajor (nRows x, nCols x, fn (i,j) => f(sub(x,i,j)))
fun map2 f (x, y) =
    tabulate RowMajor (nRows x, nCols x, fn (i,j) => f(sub(x,i,j),sub(y,i,j)))
fun scalarMatrix(m, x) = tabulate RowMajor (m,m,fn (i,j) => if i=j then x else F.zero)
fun multc(c, x) = map (fn xij => F.*(c,xij)) x
val op + = map2 F.+
val op - = map2 F.-
fun column(x,i) = A.fromVector(Array2.column(x,i))
fun row(x,i) = A.fromVector(Array2.row(x,i))
fun x*y = tabulate RowMajor (nRows x, nCols y,
			     fn (i,j) => A.dot(row(x,i), column(y,j)))
fun multa(x,a) = Array.tabulate (nRows x, fn i => A.dot(row(x,i), a))
fun copy x = map (fn x => x) x
fun subMatrix(h, i1, i2, j1, j2) =
    tabulate RowMajor (Int.+(Int.-(i2,i1),1),
		       Int.+(Int.-(j2,j1),1),
		       fn (a,b) => sub(h,Int.+(i1,a),Int.+(j1,b)))
fun transpose m = tabulate RowMajor (nCols m,
				     nRows m,
				     fn (i,j) => sub(m,j,i))
fun updateSubMatrix(h,i,j,s) =
    tabulate RowMajor (nRows s, nCols s, fn (a,b) => update(h,Int.+(i,a),Int.+(j,b),sub(s,a,b)))
end
end
fun toList a =
    List.tabulate(Array2.nRows a, fn i => List.tabulate(Array2.nCols a, fn j => Array2.sub(a,i,j)))
fun householder a =
    let open Array
	val m = length a
	val len = F.sqrt(A.dot(a,a))
	val u = A.+(a, A.multc(F.*(len,F.sign(sub(a,0))), A.unitVector m))
	val v = A.multc(F./(F.one,sub(u,0)), u)
	val beta = F./(F.+(F.one,F.one),A.dot(v,v))
    in
	M.-(M.scalarMatrix(m,F.one), M.multc(beta,A.outer F.* (v,v)))
    end
fun qr mat =
    let open Array2
	val (m,n) = dimensions mat
	val upperIndex = if m=n then Int.-(n,1) else n
	fun loop(i,qm,rm) = if i=upperIndex then {q=qm,r=rm} else
			    let val x = A.slice(A.fromVector(column(rm,i)),i,NONE)
				val h = M.scalarMatrix(m,F.one)
				val _ = M.updateSubMatrix(h,i,i,householder x)
			    in
				loop(Int.+(i,1), M.*(qm,h), M.*(h,rm))
			    end
    in
	loop(0, M.scalarMatrix(m,F.one), mat)
    end
fun solveUpperTriangular(r,b) =
    let open Array
	val n = Array2.nCols r
	val x = array(n, F.zero)
	fun loop k =
	    let val index = Int.min(Int.-(n,1),Int.+(k,1))
		val _ = update(x,k,
			       F./(F.-(sub(b,k),
				       A.dot(A.slice(x,index,NONE),
					     A.slice(M.row(r,k),index,NONE))),
				   Array2.sub(r,k,k)))
	    in
		if k=0 then x else loop(Int.-(k,1))
	    end
    in
	loop (Int.-(n,1))
    end
fun lsqr(a,b) =
    let val {q,r} = qr a
	val n = Array2.nCols r
    in
	solveUpperTriangular(M.subMatrix(r, 0, Int.-(n,1), 0, Int.-(n,1)),
			     M.multa(M.transpose(q), b))
    end
fun pow(x,1) = x
  | pow(x,n) = F.*(x,pow(x,Int.-(n,1)))
fun polyfit(x,y,n) =
    let open Array2
	val a = tabulate RowMajor (Array.length x,
				   Int.+(n,1),
				   fn (i,j) => if j=0 then F.one else
					       pow(Array.sub(x,i),j))
    in
	lsqr(a,y)
    end
end
