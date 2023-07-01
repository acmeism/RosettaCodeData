open System

let rec gcd x y = if x = y || x = 0 then y else if x < y then gcd y x else gcd y (x-y)
let abs (x : int) = Math.Abs x
let sign (x: int) = Math.Sign x
let cint s = Int32.Parse(s)

type Rat(x : int, y : int) =
    let g = if y = 0 then 0 else gcd (abs x) (abs y)
    member this.n = if g = 0 then sign y * sign x else sign y * x / g   // store a minus sign in the numerator
    member this.d =
        if y = 0 then 0 else sign y * y / g
    static member (~-) (x : Rat) = Rat(-x.n, x.d)
    static member (+) (x : Rat, y : Rat) = Rat(x.n * y.d + y.n * x.d, x.d * y.d)
    static member (-) (x : Rat, y : Rat) = x + Rat(-y.n, y.d)
    static member (*) (x : Rat, y : Rat) = Rat(x.n * y.n, x.d * y.d)
    static member (/) (x : Rat, y : Rat) = x * Rat(y.d, y.n)
    interface System.IComparable with
      member this.CompareTo o =
        match o with
        | :? Rat as that -> compare (this.n * that.d) (that.n * this.d)
        | _ -> invalidArg "o" "cannot compare values of differnet types."
    override this.Equals(o) =
        match o with
        | :? Rat as that -> this.n = that.n && this.d = that.d
        | _ -> false
    override this.ToString() =
        if this.d = 1 then this.n.ToString()
        else sprintf @"<%d,%d>" this.n this.d
    new(x : string, y : string) = if y = "" then Rat(cint x, 1) else Rat(cint x, cint y)

type expression =
    | Const of Rat
    | Sum  of expression * expression
    | Diff of expression * expression
    | Prod of expression * expression
    | Quot of expression * expression

let rec eval = function
    | Const c -> c
    | Sum (f, g) -> eval f + eval g
    | Diff(f, g) -> eval f - eval g
    | Prod(f, g) -> eval f * eval g
    | Quot(f, g) -> eval f / eval g

let print_expr expr =
    let concat (s : seq<string>) = System.String.Concat s
    let paren p prec op_prec = if prec > op_prec then p else ""
    let rec print prec = function
    | Const c -> c.ToString()
    | Sum(f, g) ->
        concat [ (paren "(" prec 0); (print 0 f); " + "; (print 0 g); (paren ")" prec 0) ]
    | Diff(f, g) ->
        concat [ (paren "(" prec 0); (print 0 f); " - "; (print 1 g); (paren ")" prec 0) ]
    | Prod(f, g) ->
        concat [ (paren "(" prec 2); (print 2 f); " * "; (print 2 g); (paren ")" prec 2) ]
    | Quot(f, g) ->
        concat [ (paren "(" prec 2); (print 2 f); " / "; (print 3 g); (paren ")" prec 2) ]
    print 0 expr

let rec normal expr =
    let norm epxr =
        match expr with
        | Sum(x, y) -> if eval x <= eval y then expr else Sum(normal y, normal x)
        | Prod(x, y) -> if eval x <= eval y then expr else Prod(normal y, normal x)
        | _ -> expr
    match expr with
    | Const c -> expr
    | Sum(x, y) -> norm (Sum(normal x, normal y))
    | Prod(x, y) -> norm (Prod(normal x, normal y))
    | Diff(x, y) -> Diff(normal x, normal y)
    | Quot(x, y) -> Quot(normal x, normal y)

let rec insert v = function
    | [] -> [[v]]
    | x::xs as li -> (v::li) :: (List.map (fun y -> x::y) (insert v xs))

let permutations li =
    List.foldBack (fun x z -> List.concat (List.map (insert x) z)) li [[]]

let rec comp expr rest = seq {
    match rest with
    | x::xs ->
        yield! comp (Sum (expr, x)) xs;
        yield! comp (Diff(x, expr)) xs;
        yield! comp (Diff(expr, x)) xs;
        yield! comp (Prod(expr, x)) xs;
        yield! comp (Quot(x, expr)) xs;
        yield! comp (Quot(expr, x)) xs;
    | [] -> if eval expr = Rat(24,1) then yield print_expr (normal expr)
}

[<EntryPoint>]
let main argv =
    let digits = List.init 4 (fun i -> Const (Rat(argv.[i],"")))
    let solutions =
        permutations digits
        |> Seq.groupBy (sprintf "%A")
        |> Seq.map snd |> Seq.map Seq.head
        |> Seq.map (fun x -> comp (List.head x) (List.tail x))
        |> Seq.choose (fun x -> if Seq.isEmpty x then None else Some x)
        |> Seq.concat
    if Seq.isEmpty solutions then
        printfn "No solutions."
    else
        solutions
        |> Seq.groupBy id
        |> Seq.iter (fun x -> printfn "%s" (fst x))
    0
