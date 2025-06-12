// Z combinator. Nigel Galloway: March 5th., 2024
type Mu<'T> = { eval: Mu<'T> -> ('T -> 'T) }
let Z f = let g = { eval = fun x -> fun v -> (f (x.eval x)) v } in (g.eval g)
let fibonacci=function 0->1 |x->let fibonacci f= function 0->0 |1->1 |x->f(x - 1) + f(x - 2) in Z fibonacci x
let factorial n=let factorial f=function 0->1 |x->x*f(x-1) in Z factorial n
printfn "fibonacci 10 = %d\nfactorial 5 = %d" (fibonacci 10) (factorial 5)
