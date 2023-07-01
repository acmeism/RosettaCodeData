let sortDisjointSubarray data indices =
  let indices = Set.toArray indices // creates a sorted array
  let result = Array.copy data
  Array.map (Array.get data) indices
  |> Array.sort
  |> Array.iter2 (Array.set result) indices
  result


printfn "%A" (sortDisjointSubarray [|7;6;5;4;3;2;1;0|] (set [6;1;7]))
