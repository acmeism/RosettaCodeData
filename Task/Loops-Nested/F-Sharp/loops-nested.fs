//Nigel Galloway: November 10th., 2017
let n = System.Random()
let g = Array2D.init 8 8 (fun _ _ -> 1+n.Next()%20)
Array2D.iter (fun n -> printf "%d " n) g; printfn ""
g |> Seq.cast<int> |> Seq.takeWhile(fun n->n<20) |> Seq.iter (fun n -> printf "%d " n)
