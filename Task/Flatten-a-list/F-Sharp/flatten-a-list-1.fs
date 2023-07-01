type 'a ll =
    | I of 'a             // leaf Item
    | L of 'a ll list     // ' <- confine the syntax colouring confusion

let rec flatten = function
    | [] -> []
    | (I x)::y -> x :: (flatten y)
    | (L x)::y -> List.append (flatten x) (flatten y)

printfn "%A" (flatten [L([I(1)]); I(2); L([L([I(3);I(4)]); I(5)]); L([L([L([])])]); L([L([L([I(6)])])]); I(7); I(8); L([])])

// -> [1; 2; 3; 4; 5; 6; 7; 8]
