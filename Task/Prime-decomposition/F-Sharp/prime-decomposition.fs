let decompose_prime n =
  let rec loop c p =
    if c < (p * p) then [c]
    elif c % p = 0I then p :: (loop (c/p) p)
    else loop c (p + 1I)

  loop n 2I

printfn "%A" (decompose_prime 600851475143I)
