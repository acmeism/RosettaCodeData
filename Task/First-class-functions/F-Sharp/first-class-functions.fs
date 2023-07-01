open System

let cube x = x ** 3.0
let croot x = x ** (1.0/3.0)

let funclist = [Math.Sin; Math.Cos; cube]
let funclisti = [Math.Asin; Math.Acos; croot]
let composed = List.map2 (<<) funclist funclisti

let main() = for f in composed do printfn "%f" (f 0.5)

main()
