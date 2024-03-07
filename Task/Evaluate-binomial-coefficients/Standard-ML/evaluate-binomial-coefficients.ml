fun binomial n k =
    if k > n then 0 else
    let fun f (_, 0) = 1
          | f (i, d) = f (i + 1, d - 1) * i div d
    in f (n - k + 1, k) end
