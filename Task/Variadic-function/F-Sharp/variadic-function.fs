// Variadic function. Nigel Galloway: March 6th., 2024
open System
type X()=static member F([<ParamArray>] args: Object[]) = args|>Array.iter(printfn "%A")
X.F(23, 3.142, "Nigel", 1u, true)
