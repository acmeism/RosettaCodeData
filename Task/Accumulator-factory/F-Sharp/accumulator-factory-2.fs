let inline makeAccumulator init =
    let acc = ref init
    fun i ->
        acc := !acc + i
        !acc

do
    let acc = makeAccumulator 1.0 // create a float accumulator

    acc 5.0 |> ignore
    let _ = makeAccumulator 3 // create an unused integer accumulator
    printfn "%A" (acc 2.3)
