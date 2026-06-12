// Minimum number of cells after, before, above and below NxN squares. Nigel Galloway: August 1st., 2021
printfn "%A"   (Array2D.init 10 10 (fun n g->List.min [n;g;9-n;9-g]))
printfn "\n%A" (Array2D.init  9  9 (fun n g->List.min [n;g;8-n;8-g]))
