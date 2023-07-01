// We can use Some as return, Option.bind and the pipeline operator in order to have a very concise code


let f1 (v:int) = Some v  // int -> Option<int>
let f2 (v:int) = Some(string v) // int -> Option<sting>

f1 4 |> Option.bind f2 |> printfn "Value is %A"  // bind when option (maybe) has data
None |> Option.bind f2 |> printfn "Value is %A" // bind when option (maybe) does not have data
