// Calculate the inverse of a (mod m)
// See here for eea specs:
// https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
let modInv m a =
  let rec eea t t' r r' =
    match r' with
    | 0 -> t
    | _ ->
      let div = r/r'
      eea t' (t - div * t') r' (r - div * r')
  (m + eea 0 1 m a) % m
