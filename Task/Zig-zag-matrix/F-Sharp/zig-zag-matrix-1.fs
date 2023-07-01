//Produce a zig zag matrix - Nigel Galloway: April 7th., 2015
let zz l a =
  let N = Array2D.create l a 0
  let rec gng (n, i, g, e) =
    N.[n,i] <- g
    match e with
    | _ when i=a-1 && n=l-1 -> N
    | 1 when n = l-1        -> gng (n, i+1, g+1, 2)
    | 2 when i = a-1        -> gng (n+1, i, g+1, 1)
    | 1 when i = 0          -> gng (n+1, 0, g+1, 2)
    | 2 when n = 0          -> gng (0, i+1, g+1, 1)
    | 1                     -> gng (n+1, i-1, g+1, 1)
    | _                     -> gng (n-1, i+1, g+1, 2)
  gng (0, 0, 0, 2)
