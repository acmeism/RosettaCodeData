let rec fact n g=if n<2 then g else fact (n-1) n*g
[1..6] |> List.iter(fun n->let nLS=normLS n|>Seq.length in printfn "order=%d number of Reduced Latin Squares nLS=%d nLS*n!*(n-1)!=%d" n nLS (nLS*(fact n 1)*(fact (n-1) 1)))
