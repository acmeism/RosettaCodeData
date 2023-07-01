import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.List (intercalate, transpose)
import Data.List.Split (chunksOf, splitWhen)
import Data.Numbers.Primes (primeFactors)
import Text.Printf (printf)

-------------------- BRILLIANT NUMBERS -------------------

isBrilliant :: (Integral a, Show a) => a -> Bool
isBrilliant n = case primeFactors n of
  [a, b] -> length (show a) == length (show b)
  _ -> False

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let indexedBrilliants =
        zip
          [1 ..]
          (filter isBrilliant [1 ..])

  putStrLn $
    table "  " $
      chunksOf 10 $
        show . snd
          <$> take 100 indexedBrilliants

  putStrLn "(index, brilliant)"
  mapM_ print $
    take 6 $
      fmap (fst . head) $
        splitWhen
          (uncurry (<) . join bimap (length . show . snd))
          $ zip indexedBrilliants (tail indexedBrilliants)

------------------------- DISPLAY ------------------------

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
