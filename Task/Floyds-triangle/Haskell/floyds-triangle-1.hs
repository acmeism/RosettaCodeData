import Control.Monad (liftM2)

floydTriangle =
  liftM2
    (zipWith (liftM2 (.) enumFromTo ((pred .) . (+))))
    (scanl (+) 1)
    id
    [1 ..]

alignR :: Int -> Integer -> String
alignR n = (\s -> replicate (n - length s) ' ' ++ s) . show

formatFT :: Int -> IO ()
formatFT n = mapM_ (putStrLn . unwords . zipWith alignR ws) t
  where
    t = take n floydTriangle
    ws = map (length . show) $ last t
