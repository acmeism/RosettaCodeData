import Data.List (unfoldr)
import System.Random (newStdGen, randomRs)

bnd :: String -> Char
bnd "_##" = '#'
bnd "#_#" = '#'
bnd "##_" = '#'
bnd _ = '_'

nxt :: String -> String
nxt = unfoldr go . ('_' :) . (<> "_")
  where
    go [_, _] = Nothing
    go xs = Just (bnd $ take 3 xs, drop 1 xs)

lahmahgaan :: String -> [String]
lahmahgaan xs =
  init
    . until
      ((==) . last <*> last . init)
      ((<>) <*> pure . nxt . last)
    $ [xs, nxt xs]

main :: IO ()
main =
  newStdGen
    >>= ( mapM_ putStrLn . lahmahgaan
            . map ("_#" !!)
            . take 36
            . randomRs (0, 1)
        )
