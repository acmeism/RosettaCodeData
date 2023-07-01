import Data.List
import qualified Data.Char as Ch

toLower :: String -> String
toLower = map Ch.toLower

isExt :: String -> [String] -> Bool
isExt filename extensions = any (`elem` (tails . toLower $ filename)) $ map toLower extensions
