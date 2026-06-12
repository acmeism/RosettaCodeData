// Matrix with two diagonals. Nigel Galloway: February 17th., 2022
let m11 m=Array2D.init m m (fun n g->if n=g || n+g=m-1 then 1 else 0)
printfn "%A\n\n%A" (m11 5) (m11 6)
