// Mayan numerals. Nigel Galloway: February 19th., 2021
let N=[|"│    ";"│.   ";"│..  ";"│... ";"│....";"│~~~~"|]
let     fN g=(fun(n)->if g=0 && n=0 then "│ Θ  " else N.[let g=g-5*n in if g>4 then 5 else if g<0 then 0 else g])
let rec fG n g=match n/20L,n%20L with (0L,0L)->(g,List.length g) |(i,n)->fG i ((fN(int n))::g)
let mayan n=let n,g=fG n []
            printf "┌────"; for _ in 2..g do printf "┬────"
            printfn "┐"; for g in 3.. -1 ..0 do n|>List.iter(fun n->printf "%s" (n(g))); printfn "│"
            printf "└────"; for _ in 2..g do printf "┴────"
            printfn "┘"
[4005L;8017L;326205L;886205L]|>List.iter(fun n->printfn "%d" n; mayan n)
