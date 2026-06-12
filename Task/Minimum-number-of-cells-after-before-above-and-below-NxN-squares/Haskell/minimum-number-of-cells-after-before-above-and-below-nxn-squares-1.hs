import Data.List.Split (chunksOf)

----------- SHORTEST DISTANCES TO EDGE OF MATRIX ---------

distancesToEdge :: Int -> [[Int]]
distancesToEdge n =
  ( \i ->
      chunksOf n $
        (\(x, y) -> minimum [x, y, i - x, i - y])
          <$> (fmap (,) >>= (<*>)) [0 .. i]
  )
    $ pred n

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    showMatrix . distancesToEdge <$> [10, 9, 2, 1]

------------------------- DISPLAY ------------------------

showMatrix :: Show a => [[a]] -> String
showMatrix m =
  let w = (succ . maximum) $ fmap (length . show) =<< m
      rjust n c = (drop . length) <*> (replicate n c <>)
   in unlines (unwords . fmap (rjust w ' ' . show) <$> m)
