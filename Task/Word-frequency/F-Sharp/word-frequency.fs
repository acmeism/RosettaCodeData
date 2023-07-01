open System.IO
open System.Text.RegularExpressions
let g=Regex("[A-Za-zÀ-ÿ]+").Matches(File.ReadAllText "135-0.txt")
[for n in g do yield n.Value.ToLower()]|>List.countBy(id)|>List.sortBy(fun n->(-(snd n)))|>List.take 10|>List.iter(fun n->printfn "%A" n)
