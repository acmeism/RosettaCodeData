let
    polyfix= // A version that takes an array instead of multiple arguments would simply use l instead of (...l) for parameter
        (...l)=>(
            (f=>f(f))
            (g=>l.map(f=>(...x)=>f(...g(g))(...x)))),
    [even,odd]= // The new destructive assignment syntax for arrays
        polyfix(
            (even,odd)=>n=>(n===0)||odd(n-1),
            (even,odd)=>n=>(n!==0)&&even(n-1));
