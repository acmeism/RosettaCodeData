// Merge and aggregate datasets. Nigel Galloway: January 6th., 2021
let rFile(fName)=seq{use n=System.IO.File.OpenText(fName)
                     n.ReadLine() |> ignore
                     while not n.EndOfStream do yield n.ReadLine().Split [|','|]}
let N=rFile("file1.txt") |> Seq.sort
let G=rFile("file2.txt") |> Seq.groupBy(fun n->n.[0]) |> Map.ofSeq
let fN n i g e l=printfn "| %-10s | %-8s | %10s |  %-9s | %-9s |" n i g e l
let fG n g=let z=G.[n]|>Seq.sumBy(fun n->try float n.[2] with :? System.FormatException->0.0)
           fN n g (G.[n]|>Seq.sort|>Seq.last).[1] (if z=0.0 then "" else string z) (if z=0.0 then "" else string(z/(float(Seq.length G.[n]))))
