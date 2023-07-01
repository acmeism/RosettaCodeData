// Generate emirps. Nigel Galloway: November 19th., 2017
let emirp =
  let rec fN n g = match n with |0->g |_->fN (n/10) (g*10+n%10)
  let     fG n g = n<>g && isPrime g
  primes32() |> Seq.filter (fun n -> fG n (fN n 0))
