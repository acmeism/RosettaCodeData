{-# language LambdaCase #-}

showPoly [] = "0"
showPoly p = foldl1 (\r -> (r ++) . term) $
             dropWhile null $
             foldMap (\(c, n) -> [show c ++ expt n]) $
             zip p [0..]
  where
    expt = \case 0 -> ""
                 1 -> "*x"
                 n -> "*x^" ++ show n

    term = \case [] -> ""
                 '0':'*':t -> ""
                 '-':'1':'*':t -> " - " ++ t
                 '1':'*':t -> " + " ++ t
                 '-':t -> " - " ++ t
                 t -> " + " ++ t

main = mapM_ (putStrLn . line) ps
  where
    line p = "\np  = " ++ showPoly p ++ "\np' = " ++ showPoly (deriv p)
    ps = [[5],[4,-3],[-1,6,5],[-4,3,-2,1],[1,1,0,-1,-1]]
