// Words which containing all the vowels once . Nigel Galloway: February 17th., 2021
let fN g=if String.length g < 11 then false else let n=Map.ofSeq (Seq.countBy id g) in let fN g=n.ContainsKey g && n.[g]=1 in fN 'a' && fN 'i' && fN 'o' && fN 'u' && fN 'e'
seq{use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()}|>Seq.filter fN|>Seq.iter(printfn "%s")
