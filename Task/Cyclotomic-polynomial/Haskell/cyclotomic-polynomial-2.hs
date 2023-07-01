showPoly [] = "0"
showPoly p = foldl1 (\r -> (r ++) . term) $
             dropWhile null $
             foldMap (\(c, n) -> [show c ++ expt n]) $
             zip (reverse p) [0..]
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

main = do
  mapM_ (print . showPoly . cyclotomic) [1..30]
  putStrLn $ replicate 40 '-'

  mapM_ showLine $ take 4 task2
  where
    showLine (j, i, l) = putStrLn $ concat [ show j
                                            , " appears in CM(", show i
                                            , ") of length ", show l ]

    -- in order to make computations faster we leave only each 5-th polynomial
    task2 = (1,1,2) : tail (search 1 $ zip [0,5..] $ skipBy 5 cyclotomics)
      where
        search i ((k, p):ps) = if i `notElem` (abs <$> p)
                               then search i ps
                               else (i, k, length p) : search (i+1) ((k, p):ps)

skipBy n [] = []
skipBy n lst = let (x:_, b) = splitAt n lst in x:skipBy n b
