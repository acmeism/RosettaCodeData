import qualified Data.List as L
import qualified Data.Maybe as M

table :: String
table = ['a'..'z']

encode :: String -> [Int]
encode = snd . L.mapAccumL f table
  where
    f t s = ((s : L.delete s t), M.fromJust (L.elemIndex s t))

decode :: [Int] -> String
decode = snd . L.mapAccumL f table
  where
    f t i = let s = (t !! i) in ((s : L.delete s t), s)

main :: IO ()
main = mapM_ (\s -> let t@(e, _) = (encode s, decode e) in print t)
       ["broood", "bananaaa", "hiphophiphop"]
