open System
open System.Text.RegularExpressions

// Some utilities
let (|Parse|_|) regex str =
   let m = Regex(regex).Match(str)
   if m.Success then Some ([for g in m.Groups -> g.Value]) else None
let rec gcd x y = if x = y || x = 0 then y else if x < y then gcd y x else gcd y (x-y)
let abs (x : int) = Math.Abs x
let sign (x: int) = Math.Sign x
let cint s = Int32.Parse(s)
let replace m (s : string) t = Regex.Replace(t, m, s)

// computing in Rationals
type Rat(x : int, y : int) =
    let g = if y <> 0 then gcd (abs x) (abs y) else raise <| DivideByZeroException()
    member this.n = sign y * x / g   // store a minus sign in the numerator
    member this.d =
        if y <> 0 then sign y * y / g else raise <| DivideByZeroException()
    static member (~-) (x : Rat) = Rat(-x.n, x.d)
    static member (+) (x : Rat, y : Rat) = Rat(x.n * y.d + y.n * x.d, x.d * y.d)
    static member (-) (x : Rat, y : Rat) = x + Rat(-y.n, y.d)
    static member (*) (x : Rat, y : Rat) = Rat(x.n * y.n, x.d * y.d)
    static member (/) (x : Rat, y : Rat) = x * Rat(y.d, y.n)
    override this.ToString() = sprintf @"<%d,%d>" this.n this.d
    new(x : string, y : string) = if y = "" then Rat(cint x, 1) else Rat(cint x, cint y)

// Due to the constraints imposed by the game (reduced set
// of operators, all left associativ) we can get away with a repeated reduction
// to evaluate the algebraic expression.
let rec reduce (str :string) =
    let eval (x : Rat) (y : Rat) = function
    | "*" -> x * y | "/" -> x / y | "+" -> x + y | "-" -> x - y | _ -> failwith "unknown op"
    let subst s r = str.Replace(s, r.ToString())
    let rstr =
        match str with
        | Parse @"\(<(-?\d+),(\d+)>([*/+-])<(-?\d+),(\d+)>\)" [matched; xn; xd; op; yn; yd] ->
            subst matched <| eval (Rat(xn,xd)) (Rat(yn,yd)) op
        | Parse @"<(-?\d+),(\d+)>([*/])<(-?\d+),(\d+)>" [matched; xn; xd; op; yn; yd] ->
            subst matched <| eval (Rat(xn,xd)) (Rat(yn,yd)) op
        | Parse @"<(-?\d+),(\d+)>([+-])<(-?\d+),(\d+)>" [matched; xn; xd; op; yn; yd] ->
            subst matched <| eval (Rat(xn,xd)) (Rat(yn,yd)) op
        | Parse @"\(<(-?\d+),(\d+)>\)" [matched; xn; xd] ->
            subst matched <| Rat(xn,xd)
        | Parse @"(?<!>)-<(-?\d+),(\d+)>" [matched; xn; xd] ->
            subst matched <| -Rat(xn,xd)
        | _ -> str
    if str = rstr then str else reduce rstr

let gameLoop() =
    let checkInput dddd input =
        match input with
        | "n" | "q" -> Some(input)
        | Parse @"[^1-9()*/+-]" [c] ->
            printfn "You used an illegal character in your expression: %s" c
            None
        | Parse @"^\D*(\d)\D+(\d)\D+(\d)\D+(\d)(?:\D*(\d))*\D*$" [m; d1; d2; d3; d4; d5] ->
            if d5 = "" && (String.Join(" ", Array.sort [|d1;d2;d3;d4|])) = dddd then Some(input)
            elif d5 = "" then
                printfn "Use this 4 digits with operators in between: %s." dddd
                None
            else
                printfn "Use only this 4 digits with operators in between: %s." dddd
                None
        | _ ->
            printfn "Use all 4 digits with operators in between: %s." dddd
            None

    let rec userLoop dddd  =
        let tryAgain msg =
            printfn "%s" msg
            userLoop dddd
        printf "[Expr|n|q]: "
        match Console.ReadLine() |> replace @"\s" "" |> checkInput dddd with
        | Some(input) ->
            let data = input |> replace @"((?<!\d)-)?\d+" @"<$&,1>"
            match data with
            | "n" -> true | "q" -> false
            | _ ->
                try
                    match reduce data with
                    | Parse @"^<(-?\d+),(\d+)>$" [_; x; y] ->
                        let n, d = (cint x), (cint y)
                        if n = 24 then
                            printfn "Correct!"
                            true
                        elif d=1 then tryAgain <| sprintf "Wrong! Value = %d." n
                        else tryAgain <| sprintf "Wrong! Value = %d/%d." n d
                    | _ -> tryAgain "Wrong! not a well-formed expression!"
                with
                    | :? System.DivideByZeroException ->
                        tryAgain "Wrong! Your expression results in a division by zero!"
                    | ex ->
                        tryAgain <| sprintf "There is an unforeseen problem with yout input: %s" ex.Message
        | None -> userLoop dddd

    let random = new Random(DateTime.Now.Millisecond)
    let rec loop() =
        let dddd = String.Join(" ", Array.init 4 (fun _ -> 1 + random.Next 9) |> Array.sort)
        printfn "\nCompute 24 from the following 4 numbers: %s" dddd
        printfn "Use them in any order with * / + - and parentheses; n = new numbers; q = quit"
        if userLoop dddd then loop()

    loop()

gameLoop()
