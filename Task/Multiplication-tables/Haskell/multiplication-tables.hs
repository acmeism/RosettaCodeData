import Data.Monoid ((<>))
import Data.List (intercalate, transpose)

multTable :: Int -> [[String]]
multTable n =
  let xs = [1 .. n]
  in xs >>=
     \x ->
        [ show x <> ":" :
          (xs >>=
           \y ->
              [ if y < x
                  then mempty
                  else show (x * y)
              ])
        ]

table :: String -> [[String]] -> [String]
table delim rows =
  let justifyRight c n s = drop (length s) (replicate n c <> s)
  in intercalate delim <$>
     transpose
       ((fmap =<< justifyRight ' ' . maximum . fmap length) <$> transpose rows)

main :: IO ()
main = (putStrLn . unlines . table "  " . multTable) 12
