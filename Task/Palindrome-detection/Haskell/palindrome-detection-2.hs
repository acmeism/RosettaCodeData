import Data.Bifunctor (second)
import Data.Char (toLower)

------------------- PALINDROME DETECTION -----------------

isPalindrome :: Eq a => [a] -> Bool
isPalindrome = (==) <*> reverse

-- Or, comparing just the leftward characters with
-- with a reflection of just the rightward characters.

isPal :: String -> Bool
isPal s =
  let (q, r) = quotRem (length s) 2
   in uncurry (==) $
        second (reverse . drop r) $ splitAt q s

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    (showResult <$> [isPalindrome, isPal])
      <*> fmap
        prepared
        [ "",
          "a",
          "ab",
          "aba",
          "abba",
          "In girum imus nocte et consumimur igni"
        ]

prepared :: String -> String
prepared cs = [toLower c | c <- cs, ' ' /= c]

showResult f s = (show s) <> " -> " <> show (f s)
