// Magic numbers. Nigel Galloway: February 10th., 2023
let digs=[|0..10|]|>Array.map(System.UInt128.CreateChecked)
let fN n g=n|>List.collect(fun n->let n=n*digs[10] in [for g in digs[0..9]->n+g]|>List.filter(fun n->n%g=digs[0]))
let fG (n:int []) g=let rec fN g=if g<digs[10] then n[int g]<-n[int g]-1 else n[int(g%digs[10])]<-n[int(g%digs[10])]-1; fN (g/digs[10])
                    fN g; Array.forall ((=)0) n
let magic=Array.append [|[digs[0]..digs[9]]|] (Array.unfold(fun(n,g)->match n with []->None |n->let n=fN n g in Some(n,(n,g+digs[1])))([digs[1]..digs[9]],digs[2]))
printfn $"There are %d{magic|>Array.sumBy(List.length)} Magic numbers"
magic|>Array.iteri(fun n g->printfn "There are %d magic numbers of length %d" (List.length g) (n+1))
printfn $"Largest magic number is %A{magic.[magic.Length-2]|>List.max}"
printf "Minimally pan-digital(1..9) magic numbers are: "; magic[8]|>List.filter(fun n->fG [|0;1;1;1;1;1;1;1;1;1|] n)|>List.iter(printf "%A ");printfn ""
printf "Minimally pan-digital(1..9) magic numbers are: "; magic[9]|>List.filter(fun n->fG [|1;1;1;1;1;1;1;1;1;1|] n)|>List.iter(printf "%A ");printfn ""9
