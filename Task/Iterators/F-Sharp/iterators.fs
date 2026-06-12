//Iterators. Nigel Galloway: Januuary 30th., 2022
let N,G=[|"Sunday"; "Monday"; "Tuesday"; "Wednesday"; "Thursday"; "Friday"; "Saturday"|],["Red"; "Orange"; "Yellow"; "Green"; "Blue"; "Purple"]
N|>Array.iter(printf "%s "); printfn ""
N|>Seq.iter(printf "%s "); printfn ""
G|>List.iter(printf "%s "); printfn ""
G|>Seq.iter(printf "%s "); printfn ""

let rec advance(n:System.Collections.IEnumerator)=function 0->() |g->n.MoveNext(); advance n (g-1)
let next(n:System.Collections.IEnumerator)=n.MoveNext(); n.Current

let X=(N|>Seq.ofArray).GetEnumerator() in printfn $"{next X} {(advance X 2; next X)} {next X}"
let X=(G|>Seq.ofList).GetEnumerator() in printfn $"{next X} {(advance X 2; next X)} {next X}"
let X=(N|>Array.rev|>Seq.ofArray).GetEnumerator() in printfn $"{next X} {(advance X 3; next X)} {next X}"
let X=(G|>List.rev|>Seq.ofList).GetEnumerator() in printfn $"{next X} {(advance X 3; next X)} {next X}"
