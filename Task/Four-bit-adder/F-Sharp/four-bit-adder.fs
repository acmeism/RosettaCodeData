type Bit =
    | Zero
    | One

let bNot = function
    | Zero -> One
    | One -> Zero

let bAnd a b =
    match (a, b) with
    | (One, One) -> One
    | _ -> Zero

let bOr a b =
    match (a, b) with
    | (Zero, Zero) -> Zero
    | _ -> One

let bXor a b = bAnd (bOr a b) (bNot (bAnd a b))

let bHA a b = bAnd a b, bXor a b

let bFA a b cin =
    let (c0, s0) = bHA a b
    let (c1, s1) = bHA s0 cin
    (bOr c0 c1, s1)

let b4A (a3, a2, a1, a0) (b3, b2, b1, b0) =
    let (c1, s0) = bFA a0 b0 Zero
    let (c2, s1) = bFA a1 b1 c1
    let (c3, s2) = bFA a2 b2 c2
    let (c4, s3) = bFA a3 b3 c3
    (c4, s3, s2, s1, s0)

printfn "0001 + 0111 ="
b4A (Zero, Zero, Zero, One) (Zero, One, One, One) |> printfn "%A"
