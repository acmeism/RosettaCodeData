open Microsoft.FSharp.Collections

let cholesky a =
    let calc (a: float[,]) (l: float[,]) i j =
        let c1 j =
            let sum = List.sumBy (fun k -> l.[j, k] ** 2.0) [0..j - 1]
            sqrt (a.[j, j] - sum)
        let c2 i j =
            let sum = List.sumBy (fun k -> l.[i, k] * l.[j, k]) [0..j - 1]
            (1.0 / l.[j, j]) * (a.[i, j] - sum)
        if j > i then 0.0 else
            if i = j
            then c1 j
            else c2 i j
    let l = Array2D.zeroCreate (Array2D.length1 a) (Array2D.length2 a)
    Array2D.iteri (fun i j _ -> l.[i, j] <- calc a l i j) l
    l

let printMat a =
    let arrow = (Array2D.length2 a |> float) / 2.0 |> int
    let c = cholesky a
    for row in 0..(Array2D.length1 a) - 1 do
        for col in 0..(Array2D.length2 a) - 1 do
            printf "%.5f,\t" a.[row, col]
        printf (if arrow = row then "--> \t" else "\t\t")
        for col in 0..(Array2D.length2 c) - 1 do
            printf "%.5f,\t" c.[row, col]
        printfn ""

let ex1 = array2D [
    [25.0; 15.0; -5.0];
    [15.0; 18.0; 0.0];
    [-5.0; 0.0; 11.0]]

let ex2 = array2D [
    [18.0; 22.0; 54.0; 42.0];
    [22.0; 70.0; 86.0; 62.0];
    [54.0; 86.0; 174.0; 134.0];
    [42.0; 62.0; 134.0; 106.0]]

printfn "ex1:"
printMat ex1

printfn "ex2:"
printMat ex2
