// Pure F# Implementation of SplitMix64
let a: uint64 = 0x9e3779b97f4a7c15UL

let nextInt (state: uint64) =
    let newstate = state + (0x9e3779b97f4a7c15UL)
    let rand = newstate
    let rand = (rand ^^^ (rand >>> 30)) * 0xbf58476d1ce4e5b9UL
    let rand = (rand ^^^ (rand >>> 27)) * 0x94d049bb133111ebUL
    let rand = rand ^^^ (rand >>> 31)
    (rand, newstate)

let nextFloat (state: uint64) =
    let (rand, newState) = nextInt state
    let randf = (rand / (1UL <<< 64)) |> float
    (randf, newState)

[<EntryPoint>]
let main argv =
    let state = 1234567UL
    let (first, state) = nextInt state
    let (second, state) = nextInt state
    let (third, state) = nextInt state
    let (fourth, state) = nextInt state
    let (fifth, state) = nextInt state
    printfn "%i" first
    printfn "%i" second
    printfn "%i" third
    printfn "%i" fourth
    printfn "%i" fifth
    0
