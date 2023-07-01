(* Find some probable candidates for The Largest Left Trucatable Prime in a given base
   Nigel Galloway: April 25th., 2017 *)
let snF Fbase pZ =
  let rec fn i g (e:bigint) l =
    match e with
    | _ when e.IsZero  -> i=1I
    | _ when e.IsEven  -> fn i ((g*g)%l) (e/2I) l
    | _                -> fn ((i*g)%l) ((g*g)%l) (e/2I) l
  let rec fi n i =
    let g = n|>Array.Parallel.collect(fun n->[|for g in 1I..(Fbase-1I) do yield g*i+n|])|>Array.filter(fun n->fn 1I 2I (n-1I) n)
    if (Array.isEmpty g) then n else (fi g (i*Fbase))
  pZ |> Array.Parallel.map (fun n -> fi [|n|] Fbase)|>Seq.concat|>Seq.max
