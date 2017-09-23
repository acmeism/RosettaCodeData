main :: IO ()
main =
  mapM_ print . reverse $
  until
    (\(x:_) -> (x > 0) && (mod x 6 == 0))
    (\xs@(x:_) -> succ x : xs)
    [0]
