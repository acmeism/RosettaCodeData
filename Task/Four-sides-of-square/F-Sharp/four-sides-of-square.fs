// Four sides of square. Nigel Galloway: February 18th., 2022
let m11 m=Array2D.init m m (fun n g->if n=0 || g=0 || g=m-1 || n=m-1 then 1 else 0)
printfn "%A\n\n%A" (m11 5) (m11 6)
