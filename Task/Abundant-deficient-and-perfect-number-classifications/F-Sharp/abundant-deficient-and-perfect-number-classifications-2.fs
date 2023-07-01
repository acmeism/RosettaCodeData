let deficient, perfect, abundant = 0,1,2

let classify n = ([1..n/2] |> List.filter (fun x->n % x = 0) |> List.sum) |> function
  | x when x<n -> deficient | x when x>n -> abundant | _ -> perfect

let incClass xs n =
  let cn = n |> classify
  xs |> List.mapi (fun i x->if i=cn then x + 1 else x)

[1..20000]
|> List.fold incClass [0;0;0]
|> List.zip [ "deficient"; "perfect"; "abundant" ]
|> List.iter (fun (label, count) -> printfn "%s: %d" label count)
