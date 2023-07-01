- datatype 'a mu = Roll of ('a mu -> 'a)
  fun unroll (Roll x) = x

  fun fix f = (fn x => fn a => f (unroll x x) a) (Roll (fn x => fn a => f (unroll x x) a))

  fun fac f 0 = 1
    | fac f n = n * f (n-1)

  fun fib f 0 = 0
    | fib f 1 = 1
    | fib f n = f (n-1) + f (n-2)
;
datatype 'a mu = Roll of 'a mu -> 'a
val unroll = fn : 'a mu -> 'a mu -> 'a
val fix = fn : (('a -> 'b) -> 'a -> 'b) -> 'a -> 'b
val fac = fn : (int -> int) -> int -> int
val fib = fn : (int -> int) -> int -> int
- List.tabulate (10, fix fac);
val it = [1,1,2,6,24,120,720,5040,40320,362880] : int list
- List.tabulate (10, fix fib);
val it = [0,1,1,2,3,5,8,13,21,34] : int list
