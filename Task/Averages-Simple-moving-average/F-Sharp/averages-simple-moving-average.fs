let sma period f (list:float list) =
    let sma_aux queue v =
        let q = Seq.truncate period (v :: queue)
        Seq.average q, Seq.toList q
    List.fold (fun s v ->
        let avg,state = sma_aux s v
        f avg
        state) [] list

printf "sma3: "
[ 1.;2.;3.;4.;5.;5.;4.;3.;2.;1.] |> sma 3 (printf "%.2f ")
printf "\nsma5: "
[ 1.;2.;3.;4.;5.;5.;4.;3.;2.;1.] |> sma 5 (printf "%.2f ")
printfn ""
