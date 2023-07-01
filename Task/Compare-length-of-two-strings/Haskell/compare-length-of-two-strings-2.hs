import qualified Data.Text as T

taskT s1 s2 = do
  let strs = if T.length s1 > T.length s2 then [s1, s2] else [s2, s1]
  mapM_ (\s -> putStrLn $ show (T.length s) ++ "\t" ++ show s) strs
