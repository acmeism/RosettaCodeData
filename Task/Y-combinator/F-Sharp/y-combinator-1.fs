// Y combinator. Nigel Galloway: March 5th., 2024
type Y<'T> = { eval: Y<'T> -> ('T -> 'T) }
let Y n g=let l = { eval = fun l -> fun x -> (n (l.eval l)) x } in  (l.eval l) g
let fibonacci=function 0->1 |x->let fibonacci f= function 0->0 |1->1 |x->f(x - 1) + f(x - 2) in Y fibonacci x
let factorial n=let factorial f=function 0->1 |x->x*f(x-1) in Y factorial n
printfn "fibonacci 10=%d\nfactorial 5=%d" (fibonacci 10) (factorial 5)
