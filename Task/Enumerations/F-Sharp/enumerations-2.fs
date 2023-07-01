type Fruit =
  | Apple
  | Banana
  | Cherry
let basket = [ Apple ; Banana ; Cherry ]
Seq.iter (printfn "%A") basket
