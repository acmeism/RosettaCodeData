open System

let seen = new System.Collections.Generic.Dictionary<string,bool>()

let lines = System.IO.File.ReadLines("unixdict.txt")

let sems = seq {
    for word in lines do
        let drow = new String(Array.rev(word.ToCharArray()))
        if fst(seen.TryGetValue(drow)) then yield (drow, word)
        seen.[drow] <- true
        seen.[word] <- true
}

let s = Seq.toList sems
printfn "%d" s.Length
for i in 0 .. 4 do printfn "%A" s.[i]
