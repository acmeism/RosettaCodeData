import qualified Data.Map as M
import Data.Maybe (isJust)

mapSample :: M.Map String Int
mapSample =
  M.fromList
    [ ("alpha", 1)
    , ("beta", 2)
    , ("gamma", 3)
    , ("delta", 4)
    , ("epsilon", 5)
    , ("zeta", 6)
    ]

maybeValue :: String -> Maybe Int
maybeValue = flip M.lookup mapSample

main :: IO ()
main =
  print $ sequence $ filter isJust (maybeValue <$> ["beta", "delta", "zeta"])
