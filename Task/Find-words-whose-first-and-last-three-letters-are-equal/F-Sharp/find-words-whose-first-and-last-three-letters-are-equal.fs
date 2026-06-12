// First and last three letters are equal. Nigel Galloway: February 18th., 2021
let fN g=if String.length g<6 then false else g.[..2]=g.[g.Length-3..]
seq{use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()}|>Seq.filter fN|>Seq.iter(printfn "%s")
