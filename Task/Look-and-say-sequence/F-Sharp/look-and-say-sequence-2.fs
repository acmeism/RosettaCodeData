let lookAndSay =
  let describe (xs: char list) =
    List.append (List.ofSeq <| (List.length xs).ToString()) [List.head xs]
  let next xs = List.collect describe (group xs)
  let toStr xs = String (Array.ofList xs)
  Seq.map toStr <| Seq.unfold (fun xs -> Some (xs, next xs)) ['1']

let getNthLookAndSay n = Seq.nth n lookAndSay

Seq.take 10 lookAndSay
