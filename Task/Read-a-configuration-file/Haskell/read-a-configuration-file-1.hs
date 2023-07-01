import Data.Char
import Data.List
import Data.List.Split

main :: IO ()
main = readFile "config" >>= (print . parseConfig)

parseConfig :: String -> Config
parseConfig = foldr addConfigValue defaultConfig . clean . lines
    where clean = filter (not . flip any ["#", ";", "", " "] . (==) . take 1)

addConfigValue :: String -> Config -> Config
addConfigValue raw config = case key of
    "fullname"       -> config {fullName      = values}
    "favouritefruit" -> config {favoriteFruit = values}
    "needspeeling"   -> config {needsPeeling  = True}
    "seedsremoved"   -> config {seedsRemoved  = True}
    "otherfamily"    -> config {otherFamily   = splitOn "," values}
    _                -> config
    where (k, vs) = span (/= ' ') raw
          key = map toLower k
          values = tail vs

data Config = Config
    { fullName      :: String
    , favoriteFruit :: String
    , needsPeeling  :: Bool
    , seedsRemoved  :: Bool
    , otherFamily   :: [String]
    } deriving (Show)

defaultConfig :: Config
defaultConfig = Config "" "" False False []
