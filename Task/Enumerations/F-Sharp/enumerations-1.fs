type Fruit =
  | Apple = 0
  | Banana = 1
  | Cherry = 2

let basket = [ Fruit.Apple ; Fruit.Banana ; Fruit.Cherry ]
Seq.iter (printfn "%A") basket
