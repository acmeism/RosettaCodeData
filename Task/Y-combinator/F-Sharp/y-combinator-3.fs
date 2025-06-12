type 'a mu = Roll of ('a mu -> 'a)  // ' fixes ease syntax colouring confusion with

let unroll (Roll x) = x
// val unroll : 'a mu -> ('a mu -> 'a)

// As with most of the strict (non-deferred or non-lazy) languages,
// this is the Z-combinator with the additional 'a' parameter...
let fix f = let g = fun x a -> f (unroll x x) a in g (Roll g)
// val fix : (('a -> 'b) -> 'a -> 'b) -> 'a -> 'b = <fun>

// Although true to the factorial definition, the
// recursive call is not in tail call position, so can't be optimized
// and will overflow the call stack for the recursive calls for large ranges...
//let fac = fix (fun f n -> if n < 2 then 1I else bigint n * f (n - 1))
// val fac : (int -> BigInteger) = <fun>

// much better progressive calculation in tail call position...
let fac = fix (fun f n i -> if i < 2 then n else f (bigint i * n) (i - 1)) <| 1I
// val fac : (int -> BigInteger) = <fun>

// Although true to the definition of Fibonacci numbers,
// this can't be tail call optimized and recursively repeats calculations
// for a horrendously inefficient exponential performance fib function...
// let fib = fix (fun fnc n -> if n < 2 then n else fnc (n - 1) + fnc (n - 2))
// val fib : (int -> BigInteger) = <fun>

// much better progressive calculation in tail call position...
let fib = fix (fun fnc f s i -> if i < 2 then f else fnc s (f + s) (i - 1)) 1I 1I
// val fib : (int -> BigInteger) = <fun>

[<EntryPoint>]
let main argv =
  fac 10 |> printfn "%A" // prints 3628800
  fib 10 |> printfn "%A" // prints 55
  0 // return an integer exit code
