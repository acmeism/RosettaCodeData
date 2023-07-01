open System

// Take from https://stackoverflow.com/a/1175123
let rec last = function
    | hd :: [] -> hd
    | _ :: tl -> last tl
    | _ -> failwith "Empty list."

let median x =
    for e in x do
        if Double.IsNaN(e) then failwith "unable to deal with lists containing NaN"

    let size = List.length(x)
    if size <= 0 then failwith "Array slice cannot be empty"
    let m = size / 2
    if size % 2 = 1 then x.[m]
    else (x.[m - 1] + x.[m]) / 2.0

let fivenum x =
    let x2 = List.sort(x)
    let m = List.length(x2) / 2
    let lowerEnd = if List.length(x2) % 2 = 1 then m else m - 1
    [List.head x2, median x2.[..lowerEnd], median x2, median x2.[m..], last x2]

[<EntryPoint>]
let main _ =
    let x1 = [
        [15.0; 6.0; 42.0; 41.0; 7.0; 36.0; 49.0; 40.0; 39.0; 47.0; 43.0];
        [36.0; 40.0; 7.0; 39.0; 41.0; 15.0];
        [
             0.14082834;  0.09748790;  1.73131507;  0.87636009; -1.95059594;
             0.73438555; -0.03035726;  1.46675970; -0.74621349; -0.72588772;
             0.63905160;  0.61501527; -0.98983780; -1.00447874; -0.62759469;
             0.66206163;  1.04312009; -0.10305385;  0.75775634;  0.32566578
        ]
    ]

    for a in x1 do
        let y = fivenum a
        Console.WriteLine("{0}", y);

    0 // return an integer exit code
