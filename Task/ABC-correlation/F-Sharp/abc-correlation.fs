// ABC correlation. Nigel Galloway: August 8th., 2024
let countChars n g=let k=Seq.zip (n|>List.distinct) (Seq.initInfinite id)|>Map.ofSeq
                   let r=Array.zeroCreate (k.Count)
                   g|>Seq.iter(fun g->match k.TryFind g with Some n->r[n]<-r[n]+1 |_->())
                   k.Keys|>Seq.map(fun n->n,r[k[n]])|>Map.ofSeq
let abc:string -> Map<char,int>=countChars ['a';'b';'c']
let predicate n=let _,g=Map.minKeyValue n in g>1 && Map.forall(fun n->(=)g) n
System.IO.File.ReadLines "words_alpha.txt"|>Seq.filter(abc>>predicate)|>Seq.iter(printfn "%s")
