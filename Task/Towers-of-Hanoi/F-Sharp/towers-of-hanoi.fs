#light
let rec hanoi num start finish =
  match num with
  | 0 -> [ ]
  | _ -> let temp = (6 - start - finish)
         (hanoi (num-1) start temp) @ [ start, finish ] @ (hanoi (num-1) temp finish)

[<EntryPoint>]
let main args =
  (hanoi 4 1 2) |> List.iter (fun pair -> match pair with
                                          | a, b -> printf "Move disc from %A to %A\n" a b)
  0
