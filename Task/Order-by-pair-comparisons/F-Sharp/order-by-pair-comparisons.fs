// Order by pair comparisons. Nigel Galloway: April 23rd., 2021
let clrs=let n=System.Random() in lN2p [|for g in 7..-1..2->n.Next(g)|] [|"Red";"Orange";"Yellow";"Green";"Blue";"Indigo";"Violet"|]
let rec fG n g=printfn "Is %s less than %s" n g; match System.Console.ReadLine() with "Yes"-> -1|"No"->1 |_->printfn "Enter Yes or No"; fG n g
let mutable z=0 in printfn "%A sorted to %A using %d questions" clrs (clrs|>Array.sortWith(fun n g->z<-z+1; fG n g)) z
