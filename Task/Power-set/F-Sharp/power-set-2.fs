let rec pow =
    function
    | [] -> [[]]
    | x::xs -> [for i in pow xs do yield! [i;x::i]]
