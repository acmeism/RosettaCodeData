import System.Random (newStdGen, randomRs)
import Control.Applicative (liftA2)
import Data.List (unfoldr)

bnd :: String -> Char
bnd bs =
  case bs of
    "_##" -> '#'
    "#_#" -> '#'
    "##_" -> '#'
    _ -> '_'

donxt :: String -> String
donxt xs =
  unfoldr
    (\xs ->
        case xs of
          [_, _] -> Nothing
          _ -> Just (bnd $ take 3 xs, drop 1 xs)) $
  '_' : xs ++ "_"

lahmahgaan :: String -> [String]
lahmahgaan xs =
  init .
  until (liftA2 (==) last (last . init)) ((++) <*> (return . donxt . last)) $
  [xs, donxt xs]

main :: IO ()
main = do
  g <- newStdGen
  let oersoep = map ("_#" !!) . take 36 $ randomRs (0, 1) g
  mapM_ print . lahmahgaan $ oersoep
