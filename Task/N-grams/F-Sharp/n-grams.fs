// N-grams. Nigel Galloway: April 2nd., 2024
let gram (n:string) g=let n=n.ToUpper() in n|>Seq.windowed g|>Seq.countBy id
for n,g in (gram "Live and let live" 2) do printfn "%A %d" n g
