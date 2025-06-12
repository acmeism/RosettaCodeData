// Y combinator with injected laziness. GordonBGood : April 18, 2025
type 'T Mu = { eval: 'T Mu -> 'T }
let Y f = let g = fun x -> f <| fun() -> (x.eval x) in g { eval = g }
let fibonacci n = Y (fun fn f s i -> if i >= n then f else fn () s (f + s) (i + 1)) 1I 1I 1
let factorial n = Y (fun f p x -> if x > n then p else f () (x * p) (x + 1I)) 1I 1I
printfn "fibonacci 10 = %A\r\nfactorial 5 = %A" (fibonacci 10) (factorial 5I)
printfn "fibonacci 1000 = %A" (fibonacci 1000)
