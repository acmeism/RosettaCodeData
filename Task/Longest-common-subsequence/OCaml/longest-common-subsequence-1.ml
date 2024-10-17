let longest xs ys = if List.length xs > List.length ys then xs else ys

let rec lcs a b = match a, b with
   [], _
 | _, []        -> []
 | x::xs, y::ys ->
    if x = y then
      x :: lcs xs ys
    else
      longest (lcs a ys) (lcs xs b)
