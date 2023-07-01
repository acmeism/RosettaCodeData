let isBalanced str =
  let rec loop count = function
    | ']'::_  when count = 0 -> false
    | '['::xs                -> loop (count+1) xs
    | ']'::xs                -> loop (count-1) xs
    | []                     -> count = 0
    | _::_                   -> false

  str |> Seq.toList |> loop 0


let shuffle arr =
    let rnd = new System.Random()
    Array.sortBy (fun _ -> rnd.Next()) arr

let generate n =
  new string( String.replicate n "[]" |> Array.ofSeq |> shuffle )


for n in 1..10 do
  let s = generate n
  printfn "\"%s\" is balanced: %b" s (isBalanced s)
