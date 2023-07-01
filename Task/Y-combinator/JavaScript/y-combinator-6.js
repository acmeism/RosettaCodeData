let
    Y= // Except for the η-abstraction necessary for applicative order languages, this is the formal Y combinator.
        f=>((g=>(f((...x)=>g(g)(...x))))
            (g=>(f((...x)=>g(g)(...x))))),
    Y2= // Using β-abstraction to eliminate code repetition.
        f=>((f=>f(f))
            (g=>(f((...x)=>g(g)(...x))))),
    Y3= // Using β-abstraction to separate out the self application combinator δ.
        ((δ=>f=>δ(g=>(f((...x)=>g(g)(...x)))))
         ((f=>f(f)))),
    fix= // β/η-equivalent fix point combinator. Easier to convert to memoise than the Y combinator.
        (((f)=>(g)=>(h)=>(f(h)(g(h)))) // The Substitute combinator out of SKI calculus
         ((f)=>(g)=>(...x)=>(f(g(g)))(...x)) // S((S(KS)K)S(S(KS)K))(KI)
         ((f)=>(g)=>(...x)=>(f(g(g)))(...x))),
    fix2= // β/η-converted form of fix above into a more compact form
        f=>(f=>f(f))(g=>(...x)=>f(g(g))(...x)),
    opentailfact= // Open version of the tail call variant of the factorial function
        fact=>(n,m=1)=>n<2?m:fact(n-1,n*m);
    tailfact= // Tail call version of factorial function
        Y(opentailfact);
