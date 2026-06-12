import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.List (isSuffixOf)

--------------- NUMBERS WITH STEADY SQUARES --------------

steadyPair :: Int -> Int -> [(Int, (String, String))]
steadyPair a b =
  [ (a, ab)
    | let ab = join bimap show (a, b),
      uncurry isSuffixOf ab
  ]

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    unlines
      ( uncurry ((<>) . (<> " -> ")) . snd
          <$> takeWhile
            ((10000 >) . fst)
            ( concat $
                zipWith
                  steadyPair
                  [0 ..]
                  (scanl (+) 0 [1, 3 ..])
            )
      )
