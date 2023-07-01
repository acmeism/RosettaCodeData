nthRoot :: Double -> Double -> Double
nthRoot n x =
  fst $
  until
    (uncurry (==))
    (((,) <*> ((/ n) . ((+) . (pn *) <*> (x /) . (** pn)))) . snd)
    (x, x / n)
  where
    pn = pred n

-------------------------- TESTS --------------------------
main :: IO ()
main =
  putStrLn $
  fTable
    "Nth roots:"
    (\(a, b) -> show a ++ " `nthRoot` " ++ show b)
    show
    (uncurry nthRoot)
    [(2, 2), (5, 34), (10, 734 ^ 10), (0.5, 7)]

-------------------- FORMAT OF RESULTS --------------------
fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  let w = maximum (length . xShow <$> xs)
      rjust n c = drop . length <*> (replicate n c ++)
  in unlines $
     s : fmap (((++) . rjust w ' ' . xShow) <*> (("  ->  " ++) . fxShow . f)) xs
