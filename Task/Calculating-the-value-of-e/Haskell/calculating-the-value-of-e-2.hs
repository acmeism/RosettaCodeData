------ APPROXIMATION OF E OBTAINED AFTER N ITERATIONS ----

eApprox n =
  snd $
    foldr
      ( \x (fl, e) ->
          (,) <*> (e +) . (1 /) $ fl * x
      )
      (1, 1)
      [n, pred n .. 1]

--------------------------- TEST -------------------------
main :: IO ()
main = print $ eApprox 20
