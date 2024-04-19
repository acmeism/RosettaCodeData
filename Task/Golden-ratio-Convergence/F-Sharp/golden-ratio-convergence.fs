// Golden ratio/Convergence. Nigel Galloway: March 8th., 2024
let ϕ=let aπ()=fun()->1M in cf2S(aπ())(aπ())
let (_,n),g=let mutable l=1 in (ϕ|>Seq.pairwise|>Seq.skipWhile(fun(n,g)->l<-l+1;abs(n-g)>1e-5M)|>Seq.head,l)
printfn "Value of ϕ is %1.14f after %d iterations error with respect to (1+√5)/2 is %1.14f" n g (abs(n-(decimal(1.0+(sqrt 5.0))/2M)))
