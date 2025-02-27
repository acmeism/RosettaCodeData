infixr 9 |>
(|>) :: (Eq a, Num a) => [a] -> [a] -> [a]
(p:ps) |> (0:qs) = p : qs*(ps |> (0:qs))
