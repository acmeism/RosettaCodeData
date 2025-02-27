eApprox n = snd $ foldr f (1, 1) [n, pred n .. 1]
  where
    f x (fl, e) =
      let y = fl * x in (y, e + 1 / y)
