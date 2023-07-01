open System
open System.IO

let longestOrderedWords() =
    let isOrdered = Seq.pairwise >> Seq.forall (fun (a,b) -> a <= b)

    File.ReadLines("unixdict.txt")
    |> Seq.filter isOrdered
    |> Seq.groupBy (fun s -> s.Length)
    |> Seq.sortBy (fst >> (~-))
    |> Seq.head |> snd

longestOrderedWords() |> Seq.iter (printfn "%s")
