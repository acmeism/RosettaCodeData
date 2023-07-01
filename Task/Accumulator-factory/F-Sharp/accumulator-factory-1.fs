// dynamically typed add
let add (x: obj) (y: obj) =
  match x, y with
  | (:? int as m), (:? int as n) -> box(m+n)
  | (:? int as n), (:? float as x)
  | (:? float as x), (:? int as n) -> box(x + float n)
  | (:? float as x), (:? float as y) -> box(x + y)
  | _ -> failwith "Run-time type error"

let acc init =
  let state = ref (box init)
  fun y ->
    state := add !state (box y)
    !state

do
  let x : obj -> obj = acc 1
  printfn "%A" (x 5) // prints "6"
  acc 3 |> ignore
  printfn "%A" (x 2.3) // prints "8.3"
