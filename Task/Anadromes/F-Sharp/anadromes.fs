// Anadromes. Nigel Galloway: June 26th., 2022
let words=seq{use n=System.IO.File.OpenText("words.txt") in while not n.EndOfStream do yield n.ReadLine()}|>Seq.filter(fun n->6<(Seq.length n))|>Seq.map(fun n->n.ToCharArray())|>Set.ofSeq
Set.intersect words (words|>Set.map(Array.rev))|>Set.iter(fun n->if n<Array.rev n then printfn "%s" (System.String n))
