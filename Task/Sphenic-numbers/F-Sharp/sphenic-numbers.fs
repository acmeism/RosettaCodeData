// Sphenic numbers. Nigel Galloway: January 23rd., 2023
let item n=Seq.item n pCache
let triplets n=n|>Seq.windowed 3|>Seq.filter(fun n->let g=fst n[0] in g+1=fst n[1] && g+2=fst n[2])
let sphenic()=let sN=System.Collections.Generic.SortedList<int,(char*int*int*int)>()
              let next()=let n=(sN.GetKeyAtIndex 0,sN.GetValueAtIndex 0) in sN.RemoveAt 0; n
              let add f n g l=sN.Add((item n)*item(g)*(item l),(f,n,g,l))
              let rec fN g=seq{match g with (y,('n',n,g,l))->yield (y,(n,g,l)); add 'n' (n+1) (g+1) (l+1); add 'l' n (g+1) (l+1); add 'g' n g (l+1); yield! fN(next())
                                           |(y,('g',n,g,l))->yield (y,(n,g,l)); add 'g' n g (l+1); yield! fN(next())
                                           |(y,('l',n,g,l))->yield (y,(n,g,l)); add 'l' n (g+1) (l+1); add 'g' n g (l+1); yield! fN(next())}
              fN(30,('n',0,1,2))
sphenic()|>Seq.takeWhile(fun(n,_)->n<1000)|>Seq.iter(fun(n,_)->printf "%d " n); printfn ""
sphenic()|>Seq.takeWhile(fun(n,_)->n<10000)|>triplets|>Seq.iter(fun n->printfn "%d %d %d" (fst n[0]) (fst n[1]) (fst n[2]))
printfn $"There are %d{sphenic()|>Seq.takeWhile(fun(n,_)->n<1000000)|>Seq.length} sphenic numbers less than 1 million"
printfn $"There are %d{sphenic()|>Seq.takeWhile(fun(n,_)->n<1000000)|>triplets|>Seq.length} sphenic triplets less than 1 million"
let y,(n,g,l)=sphenic()|>Seq.item 199999 in printfn "The 200,000th sphenic number is %d (%d %d %d)" y (item n) (item g) (item l)
let n=sphenic()|>triplets|>Seq.item 4999 in printfn "The 5,000th sphenic triplet is %d %d %d" (fst n[0]) (fst n[1]) (fst n[2])
