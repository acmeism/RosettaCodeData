let inline gnomeSort (a: _ []) =
  let rec loop i j =
    if i < a.Length then
      if a.[i-1] <= a.[i] then loop j (j+1) else
        let t = a.[i-1]
        a.[i-1] <- a.[i]
        a.[i] <- t
        if i=1 then loop j (j+1) else loop (i-1) j
  loop 1 2
