// Strange numbers. Nigel Galloway: February 25th., 2021
let pD=[0..99]|>List.map(fun n->(n/10,n%10))|>List.filter(fun(n,g)->isPrime(n+g))
pD|>List.filter(fun(n,_)->n>0)|>List.map(fun(n,g)->(n,pD|>List.filter(fun(n,_)->n=g)))
|>List.collect(fun(n,g)->g|>List.map(fun(g,k)->n*100+g*10+k))|>List.filter((>)500)|>List.iter(printf "%d ");printfn ""
