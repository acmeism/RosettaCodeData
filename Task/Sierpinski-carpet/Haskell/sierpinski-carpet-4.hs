carpet :: Int -> String
carpet = unlines . (iterate weave ["██"] !!)

weave :: [String] -> [String]
weave xs =
  let f = zipWith (++)
      g = flip f
  in [xs, fmap (const ' ') <$> xs, xs] >>= g xs . f xs

main :: IO ()
main = mapM_ (putStrLn . carpet) [0 .. 2]
