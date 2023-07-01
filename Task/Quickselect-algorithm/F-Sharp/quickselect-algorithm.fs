let rec quickselect k list =
    match list with
    | [] -> failwith "Cannot take largest element of empty list."
    | [a] -> a
    | x::xs ->
        let (ys, zs) = List.partition (fun arg -> arg < x) xs
        let l = List.length ys
        if k < l then quickselect k ys
        elif k > l then quickselect (k-l-1) zs
        else x
//end quickselect

[<EntryPoint>]
let main args =
    let v = [9; 8; 7; 6; 5; 0; 1; 2; 3; 4]
    printfn "%A" [for i in 0..(List.length v - 1) -> quickselect i v]
    0
