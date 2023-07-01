- fun cube x = Math.pow(x, 3.0);
val cube = fn : real -> real
- fun croot x = Math.pow(x, 1.0 / 3.0);
val croot = fn : real -> real
- fun compose (f, g) = fn x => f (g x); (* this is already implemented in Standard ML as the "o" operator
=                                          we could have written "fun compose (f, g) x = f (g x)" but we show this for clarity *)
val compose = fn : ('a -> 'b) * ('c -> 'a) -> 'c -> 'b
- val funclist = [Math.sin, Math.cos, cube];
val funclist = [fn,fn,fn] : (real -> real) list
- val funclisti = [Math.asin, Math.acos, croot];
val funclisti = [fn,fn,fn] : (real -> real) list
- ListPair.map (fn (f, inversef) => (compose (inversef, f)) 0.5) (funclist, funclisti);
val it = [0.5,0.5,0.500000000001] : real list
