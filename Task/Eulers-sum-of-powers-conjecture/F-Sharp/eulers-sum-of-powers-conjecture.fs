//Find 4 integers whose 5th powers sum to the fifth power of an integer (Quickly!) - Nigel Galloway: April 23rd., 2015
let G =
  let GN = Array.init<float> 250 (fun n -> (float n)**5.0)
  let rec gng (n, i, g, e) =
    match (n, i, g, e) with
    | (250,_,_,_) -> "No Solution Found"
    | (_,250,_,_) -> gng (n+1, n+1, n+1, n+1)
    | (_,_,250,_) -> gng (n, i+1, i+1, i+1)
    | (_,_,_,250) -> gng (n, i, g+1, g+1)
    | _ -> let l = GN.[n] + GN.[i] + GN.[g] + GN.[e]
           match l with
           | _ when l > GN.[249]           -> gng(n,i,g+1,g+1)
           | _ when l = round(l**0.2)**5.0 -> sprintf "%d**5 + %d**5 + %d**5 + %d**5 = %d**5" n i g e (int (l**0.2))
           | _                             -> gng(n,i,g,e+1)
  gng (1, 1, 1, 1)
