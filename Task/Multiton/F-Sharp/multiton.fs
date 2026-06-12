// Multiton. Nigel Galloway: April 1st., 2026
type Multitons= |N|I|G|E|L
module Multiton =
  let private n = Lazy.Create(fun() -> printfn "initializing";"N")
  let private i = Lazy.Create(fun() -> printfn "initializing";"I")
  let private g = Lazy.Create(fun() -> printfn "initializing";"G")
  let private e = Lazy.Create(fun() -> printfn "initializing";"E")
  let private l = Lazy.Create(fun() -> printfn "initializing";"L")
  let GetInstance=function N->n.Force|I->i.Force|G->g.Force|E->e.Force|L->l.Force

let n1=Multiton.GetInstance N
let n2=Multiton.GetInstance N
let g1=Multiton.GetInstance G
let g2=Multiton.GetInstance G
printfn "%s" (n1())
printfn "%s" (n2())
printfn "%s" (g1())
printfn "%s" (g2())
