fun fib n =
    let
	fun fib' (0,a,b) = a
	  | fib' (n,a,b) = fib' (n-1,a+b,a)
    in
	fib' (n,0,1)
    end
