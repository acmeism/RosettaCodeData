[<EntryPoint>]
let main argv =
    let x = [ 1.; 2.; 3.; 1e11 ]
    let y = List.map System.Math.Sqrt x

    let xprecision = 3
    let yprecision = 5

    use file = System.IO.File.CreateText("float.dat")
    let line = sprintf "%.*g\t%.*g"
    List.iter2 (fun x y -> file.WriteLine (line xprecision x yprecision y)) x y
    0
