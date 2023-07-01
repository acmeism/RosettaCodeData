let sum35 n = Seq.init n (id) |> Seq.reduce (fun sum i -> if i % 3 = 0 || i % 5 = 0 then sum + i else sum)

printfn "%d" (sum35 1000)
printfn "----------"

let sumUpTo (n : bigint) = n * (n + 1I) / 2I

let sumMultsBelow k n = k * (sumUpTo ((n-1I)/k))

let sum35fast n = (sumMultsBelow 3I n) + (sumMultsBelow 5I n) - (sumMultsBelow 15I n)

[for i = 0 to 30 do yield i]
|> List.iter (fun i -> printfn "%A" (sum35fast (bigint.Pow(10I, i))))
