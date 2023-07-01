open System
let monty nSims =
    let rnd = new Random()
    let SwitchGame() =
        let winner, pick = rnd.Next(0,3), rnd.Next(0,3)
        if winner <> pick then 1 else 0

    let StayGame() =
        let winner, pick = rnd.Next(0,3), rnd.Next(0,3)
        if winner = pick then 1 else 0

    let Wins (f:unit -> int) = seq {for i in [1..nSims] -> f()} |> Seq.sum
    printfn "Stay: %d wins out of %d - Switch: %d wins out of %d" (Wins StayGame) nSims (Wins SwitchGame) nSims
