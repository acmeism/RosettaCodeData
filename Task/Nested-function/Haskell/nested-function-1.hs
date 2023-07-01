import Control.Monad.ST
import Data.STRef

makeList :: String -> String
makeList separator = concat $ runST $ do
  counter <- newSTRef 1
  let makeItem item = do
        x <- readSTRef counter
        let result = show x ++ separator ++ item ++ "\n"
        modifySTRef counter (+ 1)
        return result
  mapM makeItem ["first", "second", "third"]


main :: IO ()
main = putStr $ makeList ". "
