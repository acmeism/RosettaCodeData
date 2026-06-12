import Data.Bool (bool)
import Data.List (unfoldr)
import Data.List.Split (chunksOf)
import Data.Tuple (swap)

-- DIVISIBLE BY ALL DIGITS, BUT NOT BY PRODUCT OF ALL DIGITS

p :: Int -> Bool
p n =
  ( ( (&&)
        . all
          ( (&&) . (0 /=)
              <*> (0 ==) . rem n
          )
    )
      <*> (0 /=) . rem n . product
  )
    $ digits n

digits :: Int -> [Int]
digits =
  unfoldr $
    (bool Nothing . Just . swap . flip quotRem 10) <*> (0 <)

--------------------------- TEST -------------------------
main :: IO ()
main =
  let xs = [1 .. 1000] >>= (\n -> [show n | p n])
      w = length $ last xs
   in (putStrLn . unlines) $
        unwords
          <$> chunksOf
            10
            (fmap (justifyRight w ' ') xs)

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
