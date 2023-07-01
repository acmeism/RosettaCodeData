// Dominoes: Nigel Galloway. November 17th., 2021.
let cP (n:seq<uint64 list * uint64>) g=seq{for y,n in n do for g in g do let l=n^^^g in if n+g=l then yield (g::y,l)}
let rec fG n g=match g with h::t->fG(cP n h)t |_->fst(Seq.head n)
let solve(N:int[])=let fG=let y=fG [([],0UL)]([for g in 0..47->((N.[g],N.[g+8]),(1UL<<<g)+(1UL<<<g+8))]@[for n in 0..6 do for g in n*8..n*8+6->((N.[g],N.[g+1]),(1UL<<<g)+(1UL<<<g+1))]
                                |>List.groupBy(fun((n,g),_)->(min n g,max n g))|>List.sort|>List.map(fun(_,n)->n|>List.map(fun(n,g)->g))) in (fun n g->if List.contains((1UL<<<n)+(1UL<<<g)) y then "+" else " ")
                   N|>Array.chunkBySize 8|>Array.iteri(fun n g->let n=n*8 in [0..6]|>List.iter(fun y->printf $"%d{g.[y]}%s{fG(n+y)(n+y+1)}"); printfn $"%d{g.[7]}"; [0..7]|>List.iter(fun g->printf $"%s{fG(n+g)(n+g+8)} "); printfn "")

solve [|0;5;1;3;2;2;3;1;
        0;5;5;0;5;2;4;6;
        4;3;0;3;6;6;2;0;
        0;6;2;3;5;1;2;6;
        1;1;3;0;0;2;4;5;
        2;1;4;3;3;4;6;6;
        6;4;5;1;5;4;1;4|]
