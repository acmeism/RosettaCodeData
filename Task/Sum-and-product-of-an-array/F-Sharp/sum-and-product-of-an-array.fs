let numbers = [| 1..10 |]
let sum = numbers |> Array.sum
let product = numbers |> Array.reduce (*)
