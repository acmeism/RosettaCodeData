let make2Darray (picture : string list) =
    let maxY = picture.Length
    let maxX = picture |> List.maxBy String.length |> String.length
    let arr =
        (fun y x ->
            if picture.[y].Length <= x then ' '
            else picture.[y].[x])
        |> Array2D.init maxY maxX
    (arr, maxY, maxX)

let (cube, cy, cx) =
    [
        @"///\";
        @"\\\/";
    ]
    |> make2Darray


let (p2, my, mx) =
    [
        "*****";
        "*         *    * ";
        "*         *    * ";
        "*       **********";
        "****      *    * ";
        "*         *    * ";
        "*       **********";
        "*         *    * ";
        "*         *    * ";
    ]
    |> make2Darray

let a2 = Array2D.create (cy/2 * (my+1)) (cx/2 * mx + my) ' '

let imax = my * (cy/2)
for y in 0 .. Array2D.length1 p2 - 1 do
    for x in 0 .. Array2D.length2 p2 - 1 do
        let indent = Math.Max(imax - y, 0)
        if p2.[y, x] = '*' then Array2D.blit cube 0 0 a2 y (indent+x) cy cx

Array2D.iteri (fun y x c ->
    if x = 0 then printfn ""
    printf "%c" c) a2
