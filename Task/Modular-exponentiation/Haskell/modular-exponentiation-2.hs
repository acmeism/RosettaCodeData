powerMod :: Integer -> Integer -> Integer -> Integer
powerMod b e m = x
  where
    (_, _, x) =
      until
        (\(_, e, _) -> e <= 0)
        (\(b, e, x) ->
            ( mod (b * b) m
            , div e 2
            , if 0 /= mod e 2
                then mod (b * x) m
                else x))
        (b, e, 1)

main :: IO ()
main =
  print $
  powerMod
    2988348162058574136915891421498819466320163312926952423791023078876139
    2351399303373464486466122544523690094744975233415544072992656881240319
    (10 ^ 40)
