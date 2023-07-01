let montySlower nSims =
    let rnd = new Random()
    let MontyPick winner pick =
        if pick = winner then
            [0..2] |> Seq.filter (fun i -> i <> pick) |> Seq.nth (rnd.Next(0,2))
        else
            3 - pick - winner
    let SwitchGame() =
        let winner, pick = rnd.Next(0,3), rnd.Next(0,3)
        let monty = MontyPick winner pick
        let pickFinal = 3 - monty - pick

        // Show that Monty's pick has no effect...

        if (winner <> pick) <> (pickFinal = winner) then
            printfn "Monty's selection actually had an effect!"
        if pickFinal = winner then 1 else 0

    let StayGame() =
        let winner, pick = rnd.Next(0,3), rnd.Next(0,3)
        let monty = MontyPick winner pick

        // This one's even more obvious than the above since pickFinal
        // is precisely the same as pick

        let pickFinal = pick
        if (winner = pick) <> (winner = pickFinal) then
            printfn "Monty's selection actually had an effect!"
        if winner = pickFinal then 1 else 0

    let Wins (f:unit -> int) = seq {for i in [1..nSims] -> f()} |> Seq.sum
    printfn "Stay: %d wins out of %d - Switch: %d wins out of %d" (Wins StayGame) nSims (Wins SwitchGame) nSims
