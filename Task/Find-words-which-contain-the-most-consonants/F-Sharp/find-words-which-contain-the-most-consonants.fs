// Word(s) containing most consonants. Nigel Galloway: February 18th., 2021
let vowels=set['a';'e';'i';'o';'u']
let fN g=let g=g|>Seq.filter(vowels.Contains>>not)|>Array.ofSeq in if g=(g|>Array.distinct) then g.Length else 0
printfn "%A" (seq{use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()}|>Seq.filter(fun n->n.Length>10)|>Seq.groupBy fN|>Seq.sortBy fst|>Seq.last)
