import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.List (isSuffixOf)

---------------------- STEADY NUMBERS --------------------

steadyPair :: Int -> [(String, String)]
steadyPair n =
  [ (s, s2)
    | let (s, s2) = join bimap show (n, n * n),
      s `isSuffixOf` s2
  ]

--------------------------- TEST -------------------------
main :: IO ()
main =
  ( \xs ->
      let (w, w2) = join bimap length (last xs)
       in mapM_
            ( putStrLn . uncurry ((<>) . (<> " -> "))
                . bimap
                  (justifyRight w ' ')
                  (justifyRight w2 ' ')
            )
            xs
  )
    $ [0 .. 10000] >>= steadyPair

------------------------- GENERIC ------------------------

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
