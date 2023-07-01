printfn "There are %d anti-primes less than %A:-" (List.length fL) N; for (n,g) in (List.rev fL) do printfn "%A has %d dividers" g n
