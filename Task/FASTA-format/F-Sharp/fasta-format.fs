//FASTA format. Nigel Galloway: March 23rd., 2023.
let fN(g:string)=match g[0] with '>'->printfn "\n%s:" g[1..] |_->printf "%s" g
let lines=seq{use n=System.IO.File.OpenText("testFASTA.txt") in while not n.EndOfStream do yield n.ReadLine()}
printfn "%s:" ((Seq.head lines)[1..]); Seq.tail lines|>Seq.iter fN; printfn ""
