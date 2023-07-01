[1..100]
|> List.map (fun x ->
            match x with
            | _ when x % 15 = 0 ->"fizzbuzz"
            | _ when x % 5 = 0 -> "buzz"
            | _ when x % 3 = 0 -> "fizz"
            | _ ->  x.ToString())
|> List.iter (fun x -> printfn "%s" x)
