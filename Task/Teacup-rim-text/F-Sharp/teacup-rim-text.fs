// Teacup rim text. Nigel Galloway: August 7th., 2019
let  N=System.IO.File.ReadAllLines("dict.txt")|>Array.filter(fun n->String.length n=3 && Seq.length(Seq.distinct n)>1)|>Set.ofArray
let fG z=Set.map(fun n->System.String(Array.ofSeq (Seq.permute(fun g->(g+z)%3)n))) N
Set.intersectMany [N;fG 1;fG 2]|>Seq.distinctBy(Seq.sort>>Array.ofSeq>>System.String)|>Seq.iter(printfn "%s")
