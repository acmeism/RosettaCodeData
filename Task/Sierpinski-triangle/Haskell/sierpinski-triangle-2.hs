import Data.List (intercalate)

sierpinski :: Int -> [String]
sierpinski 0 = ["▲"]
sierpinski n =
  concat $
  (<$> sierpinski (n - 1)) <$>                  -- Previous triangle,
  [ flip intercalate ([replicate (2 ^ (n - 1))] <*> " -") -- centred,
  , (++) <*> ('+' :)               -- above singly spaced duplicates.
  ]

main :: IO ()
main = mapM_ putStrLn $ sierpinski 4
