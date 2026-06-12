// Words contains more than 3 e vowels. Nigel Galloway: February 11th., 2021.
let fN g=let n=Map.ofSeq (Seq.countBy id g) in let fN g=not(n.ContainsKey g) in fN 'a' && fN 'i' && fN 'o' && fN 'u' && not(fN 'e') && n.['e']>3
seq{use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()}|>Seq.filter fN|>Seq.iter(printfn "%s")
