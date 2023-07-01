let fN g=let rec fN n=if g|>List.map(fun(g:string)->g.[0..n])|>Set.ofList|>Set.count=(List.length g) then (n+1) else fN(n+1)
         fN 0
