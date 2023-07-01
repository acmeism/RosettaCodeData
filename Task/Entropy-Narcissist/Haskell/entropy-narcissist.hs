import qualified Data.ByteString as BS
import Data.List
import System.Environment

(>>>) = flip (.)

main = getArgs >>= head >>> BS.readFile >>= BS.unpack >>> entropy >>> print

entropy = sort >>> group >>> map genericLength >>> normalize >>> map lg >>> sum
  where lg c = -c * logBase 2 c
        normalize c = let sc = sum c in map (/ sc) c
