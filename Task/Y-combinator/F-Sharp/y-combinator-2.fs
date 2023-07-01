// same as previous...
type 'a mu = Roll of ('a mu -> 'a)  // ' fixes ease syntax colouring confusion with

// same as previous...
let unroll (Roll x) = x
// val unroll : 'a mu -> ('a mu -> 'a)

// break race condition with some deferred execution - laziness...
let fix f = let g = fun x -> f <| fun() -> (unroll x x) in g (Roll g)
// val fix : ((unit -> 'a) -> 'a -> 'a) = <fun>

// same efficient version of factorial functionb with added deferred execution...
let fac = fix (fun f n i -> if i < 2 then n else f () (bigint i * n) (i - 1)) <| 1I
// val fac : (int -> BigInteger) = <fun>

// same efficient version of Fibonacci function with added deferred execution...
let fib = fix (fun fnc f s i -> if i < 2 then f else fnc () s (f + s) (i - 1)) 1I 1I
// val fib : (int -> BigInteger) = <fun>

// given the following definition for an infinite Co-Inductive Stream (CIS)...
type CIS<'a> = CIS of 'a * (unit -> CIS<'a>) // ' fix formatting

// Using a double Y-Combinator recursion...
// defines a continuous stream of Fibonacci numbers; there are other simpler ways,
// this way implements recursion by using the Y-combinator, although it is
// much slower than other ways due to the many additional function calls,
// it demonstrates something that can't be done with the Z-combinator...
let fibs() =
  let fbsgen = fix (fun fnc (CIS((f, s), rest)) ->
                 CIS((s, f + s), fun() -> fnc () <| rest()))
  Seq.unfold (fun (CIS((v, _), rest)) -> Some(v, rest()))
               <| fix (fun cis -> fbsgen (CIS((1I, 0I), cis))) // cis is a lazy thunk!

[<EntryPoint>]
let main argv =
  fac 10 |> printfn "%A" // prints 3628800
  fib 10 |> printfn "%A" // prints 55
  fibs() |> Seq.take 20 |> Seq.iter (printf "%A ")
  printfn ""
  0 // return an integer exit code
