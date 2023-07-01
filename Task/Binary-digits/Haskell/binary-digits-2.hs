import Data.Bifunctor (first)
import Data.List (unfoldr)
import Data.Tuple (swap)

---------------------- BINARY DIGITS ---------------------

binaryDigits :: Int -> String
binaryDigits = reverse . unfoldr go
  where
    go 0 = Nothing
    go n = Just . first ("01" !!) . swap . quotRem n $ 2


--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    ( putStrLn
        . ( ((<>) . (<> " -> ") . show)
              <*> binaryDigits
          )
    )
    [5, 50, 9000]
