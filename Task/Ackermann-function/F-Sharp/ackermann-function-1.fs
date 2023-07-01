let rec ackermann m n =
    match m, n with
    | 0, n -> n + 1
    | m, 0 -> ackermann (m - 1) 1
    | m, n -> ackermann (m - 1) ackermann m (n - 1)

do
    printfn "%A" (ackermann (int fsi.CommandLineArgs.[1]) (int fsi.CommandLineArgs.[2]))
