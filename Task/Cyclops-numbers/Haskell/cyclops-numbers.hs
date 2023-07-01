import Control.Monad (replicateM)
import Data.Numbers.Primes (isPrime)

--------------------- CYCLOPS NUMBERS --------------------

cyclops :: [Integer]
cyclops = [0 ..] >>= go
  where
    go 0 = [0]
    go n =
      (\s -> read s :: Integer)
        <$> (fmap ((<>) . (<> "0")) >>= (<*>))
          (replicateM n ['1' .. '9'])

blindPrime :: Integer -> Bool
blindPrime n =
  let s = show n
      m = quot (length s) 2
   in isPrime $
        (\t -> read t :: Integer)
          (take m s <> drop (succ m) s)

palindromic :: Integer -> Bool
palindromic = ((==) =<< reverse) . show

-------------------------- TESTS -------------------------
main :: IO ()
main =
  (putStrLn . unlines)
    [ "First 50 Cyclops numbers – A134808:",
      unwords (show <$> take 50 cyclops),
      "",
      "First 50 Cyclops primes – A134809:",
      unwords $ take 50 [show n | n <- cyclops, isPrime n],
      "",
      "First 50 blind prime Cyclops numbers – A329737:",
      unwords $
        take
          50
          [show n | n <- cyclops, isPrime n, blindPrime n],
      "",
      "First 50 prime palindromic cyclops numbers – A136098:",
      unwords $
        take
          50
          [show n | n <- cyclops, isPrime n, palindromic n]
    ]
