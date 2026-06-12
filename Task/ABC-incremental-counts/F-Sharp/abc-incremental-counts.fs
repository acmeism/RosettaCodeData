// ABC incremental counts. Nigel Galloway: August 29th., 2024
let abc:string -> Map<char,int>=countChars ['a';'b';'c']
let the:string -> Map<char,int>=countChars ['t';'h';'e']
let cio:string -> Map<char,int>=countChars ['c';'i';'o']
let predicate n g=let g=(Map.values>>Array.ofSeq>>Array.sort)g in g[0]>=n && g|>Array.pairwise|>Array.forall(fun(n,g)->g=n+1)
printfn "Results from unixdict.txt:"
System.IO.File.ReadLines "unixdict.txt"|>Seq.filter(abc>>predicate 1)|>Seq.iter(printfn "%s")
System.IO.File.ReadLines "unixdict.txt"|>Seq.filter(the>>predicate 1)|>Seq.iter(printfn "%s")
System.IO.File.ReadLines "unixdict.txt"|>Seq.filter(cio>>predicate 2)|>Seq.iter(printfn "%s")
printfn "\nResults from words_alpha.txt:"
System.IO.File.ReadLines "words_alpha.txt"|>Seq.filter(abc>>predicate 2)|>Seq.iter(printfn "%s")
System.IO.File.ReadLines "words_alpha.txt"|>Seq.filter(the>>predicate 2)|>Seq.iter(printfn "%s")
System.IO.File.ReadLines "words_alpha.txt"|>Seq.filter(cio>>predicate 3)|>Seq.iter(printfn "%s")
