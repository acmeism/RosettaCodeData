import Data.Monoid

main :: IO ()
main =
  let xs = [1 .. 10]
  in (putStrLn . unlines)
       [ (show . getSum     . foldr (<>) mempty) (Sum     <$> xs)
       , (show . getProduct . foldr (<>) mempty) (Product <$> xs)
       , (show .              foldr (<>) mempty) (show    <$> xs)
       , (show .              foldr (<>) mempty) (words
                     "Love is one damned thing after each other")
       ]
