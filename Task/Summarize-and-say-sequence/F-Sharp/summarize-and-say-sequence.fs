// Summarize and say sequence . Nigel Galloway: April 23rd., 2021
let rec fN g=let n=let n,g=List.head g|>List.countBy id|>List.unzip in n@(g|>List.collect(fun g->if g<10 then [g] else [g/10;g%10]))
             if List.contains n g then g.Tail|>List.rev else fN(n::g)
let rec fG n g=seq{yield! n; if g>1 then yield! fG(n|>Seq.collect(fun n->[for g in 0..List.head n->g::n]))(g-1)}
let n,g=seq{yield [0]; yield! fG(Seq.init 9 (fun n->[n+1])) 6}
        |>Seq.fold(fun(n,l) g->let g=fN [g] in match g.Length with e when e<n->(n,l) |e when e>n->(e,[[g]]) |e->(n,[g]::l))(0,[])
printfn "maximum number of iterations is %d" (n+1)
for n in g do for n in n do
                printf "Permutations of "; n.Head|>List.rev|>List.iter(printf "%d"); printfn " produce:"
                for n in n do (for n,g in List.countBy id n|>List.sort|>List.rev do printf "%d%d" g n); printfn ""
