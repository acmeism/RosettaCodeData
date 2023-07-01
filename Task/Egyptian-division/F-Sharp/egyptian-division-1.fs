// A function to perform Egyptian Division: Nigel Galloway August 11th., 2017
let egyptianDivision N G =
  let rec fn n g = seq{yield (n,g); yield! fn (n+n) (g+g)}
  Seq.foldBack (fun (n,i) (g,e)->if (i<=g) then ((g-i),(e+n)) else (g,e)) (fn 1 G |> Seq.takeWhile(fun (_,g)->g<=N)) (N,0)
