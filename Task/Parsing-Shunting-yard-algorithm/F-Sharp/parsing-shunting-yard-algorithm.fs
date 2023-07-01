open System

type action = Shift | ReduceStack | ReduceInput

type State (input : string list, stack : string list, output : string list) =
    member x.Input with get() = input
    member x.Stack with get() = stack
    member x.Output with get() = output

    member x.report act =
        let markTop = function | [] -> [] | x::xs -> ("["+x+"]")::xs
        let (s, text) =
            if x.Stack = [] && x.Input = [] then x, ""
            else
                match act with
                | Shift -> State((markTop x.Input), x.Stack, x.Output), "shift"
                | ReduceStack -> State(x.Input, (markTop x.Stack), x.Output), "reduce"
                | ReduceInput -> State((markTop x.Input), x.Stack, x.Output), "reduce"

        let lstr (x :string list) = String.Join(" ", (List.toArray x))
        printfn "%25s    %-9s %6s %s" (lstr (List.rev s.Output)) (lstr (List.rev s.Stack)) text (lstr s.Input)

    member x.shift =
        x.report Shift
        State(x.Input.Tail, (x.Input.Head)::x.Stack, x.Output)

    member x.reduce =
        x.report ReduceStack
        State (x.Input, (x.Stack.Tail), (x.Stack.Head)::x.Output)

    member x.reduceNumber =
        x.report ReduceInput
        State(x.Input.Tail, x.Stack, (x.Input.Head)::x.Output)

let prec = function
| "^" -> 4 | "*" | "/" -> 3 | "+" | "-" -> 2 | "(" -> 1
| x -> failwith ("No precedence! Not an operator: " + x)

type assocKind = | Left | Right
let assoc = function | "^" -> Right | _ -> Left

let (|Number|Open|Close|Operator|) x =
    if (Double.TryParse >> fst) x then Number
    elif x = "(" then Open
    elif x = ")" then Close
    else Operator

let rec shunting_yard (s : State) =

    let rec reduce_to_Open (s : State) =
        match s.Stack with
        | [] -> failwith "mismatched parentheses!"
        | "("::xs -> State(s.Input.Tail, xs, s.Output)
        | _ ->
            reduce_to_Open s.reduce

    let reduce_by_prec_and_shift x s =
        let (xPrec, xAssoc) = (prec x, assoc x)
        let rec loop (s : State) =
            match s.Stack with
            | [] -> s
            | x::xs ->
                let topPrec = prec x
                if xAssoc = Left && xPrec <= topPrec || xAssoc = Right && xPrec < topPrec then
                    loop s.reduce
                else
                    s
        (loop s).shift

    let rec reduce_rest (s : State) =
        match s.Stack with
        | [] -> s
        | "("::_ -> failwith "mismatched parentheses!"
        | x::_ ->
            reduce_rest s.reduce

    match s.Input with
    | x::inputRest ->
        match x with
        | Number ->
            shunting_yard s.reduceNumber
        | Open ->
            shunting_yard s.shift
        | Close ->
            shunting_yard (reduce_to_Open s)
        | Operator ->
            shunting_yard (reduce_by_prec_and_shift x s)
    | [] -> reduce_rest s

[<EntryPoint>]
let main argv =
    let input = if argv.Length = 0 then "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3".Split() else argv
    shunting_yard (State((Array.toList input), [], []))
    |> (fun s -> s.report ReduceStack)
    0
