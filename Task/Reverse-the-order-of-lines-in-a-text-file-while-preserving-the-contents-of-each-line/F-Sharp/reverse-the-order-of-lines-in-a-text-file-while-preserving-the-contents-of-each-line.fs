// Reverse the order of lines in a text file while preserving the contents of each line. Nigel Galloway: August 9th., 2022
seq{use n=System.IO.File.OpenText("wr.txt") in while not n.EndOfStream do yield n.ReadLine()}|>Seq.rev|>Seq.iter(printfn "%s")
