type ast =
    | Num  of int
    | Add  of ast * ast | Sub  of ast * ast
    | Mul  of ast * ast | Div  of ast * ast
    | Exp  of ast * ast

let (|Int|_|) = System.Int32.TryParse >> function | (true, v) -> Some(v) | (false, _) -> None

let rec parse =
    function
    | [] -> failwith "Not enough tokens"
    | (Int head)::tail -> (Num(head), tail)
    | op::tail ->
        let (left, rest1) = parse tail
        let (right, rest2) = parse rest1
        match op with
        | "+" -> (Add (right, left)), rest2
        | "-" -> (Sub (right, left)), rest2
        | "*" -> (Mul (right, left)), rest2
        | "/" -> (Div (right, left)), rest2
        | "^" -> (Exp (right, left)), rest2
        | _ -> failwith ("unknown op: " + op)

let rec infix p x  =
    let brackets (x : ast) = seq { yield "("; yield! infix 0 x; yield ")" }
    let left op context l r = seq { yield! infix context l; yield op; yield! infix context r }
    let right op context l r = seq { yield! brackets l; yield op; yield! infix context r }
    seq {
        match x with
        | Num (n) -> yield n.ToString()
        | Add (l, r) when p <= 2 -> yield! left "+" 2 l r
        | Sub (l, r) when p <= 2 -> yield! left "-" 2 l r
        | Mul (l, r) when p <= 3 -> yield! left "*" 3 l r
        | Div (l, r) when p <= 3 -> yield! left "/" 3 l r
        | Exp (Exp(ll, lr), r)   -> yield! right "^" 4 (Exp(ll,lr)) r
        | Exp (l, r)             -> yield! left "^" 4 l r
        | _ -> yield! brackets x
    }

[<EntryPoint>]
let main argv =
    let (tree, rest) =
        argv |> Array.rev |> Seq.toList |> parse
    match rest with
    | [] -> printfn "%A" tree
    | _ -> failwith ("not a valid RPN expression (excess tokens): " + System.String.Join(" ", argv))
    Seq.iter (printf " %s") (infix 0 tree); printfn ""
    0
