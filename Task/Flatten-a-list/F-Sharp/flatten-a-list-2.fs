let rec flatten =
    function
    | I x -> [x]
    | L x -> List.collect flatten x

printfn "%A" (flatten (L [L([I(1)]); I(2); L([L([I(3);I(4)]); I(5)]); L([L([L([])])]); L([L([L([I(6)])])]); I(7); I(8); L([])]))

// -> [1; 2; 3; 4; 5; 6; 7; 8]
