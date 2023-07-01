let sieve n =
  let is_prime = Array.create n true in
  let limit = truncate(sqrt (float (n - 1))) in
  for i = 2 to limit do
    if is_prime.(i) then
      let j = ref (i*i) in
      while !j < n do
        is_prime.(!j) <- false;
        j := !j + i;
      done
  done;
  is_prime.(0) <- false;
  is_prime.(1) <- false;
  is_prime
