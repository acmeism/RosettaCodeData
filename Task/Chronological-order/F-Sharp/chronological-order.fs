// Chronological order. Nigel Galloway: February 20th., 2026
let lines=System.IO.File.ReadAllLines("table.txt")
lines|>Array.sortBy(fun n->let n=n.Split(' ',System.StringSplitOptions.RemoveEmptyEntries)
                           let g=int(n[n.Length-2])
                           match n[n.Length-1] with "BCE"-> -g |_->g)|>Array.iter(printfn "%s")
