import Data.List (delete, elemIndex, mapAccumL)

import Data.Maybe (fromJust)

table :: String
table = ['a' .. 'z']

encode :: String -> [Int]
encode =
  let f t s = (s : delete s t, fromJust (elemIndex s t))
  in snd . mapAccumL f table

decode :: [Int] -> String
decode = snd . mapAccumL f table
  where
    f t i =
      let s = (t !! i)
      in (s : delete s t, s)

main :: IO ()
main =
  mapM_ print $
  (,) <*> uncurry ((==) . fst) <$> -- Test that ((fst . fst) x) == snd x)
  ((,) <*> (decode . snd) <$>
   ((,) <*> encode <$> ["broood", "bananaaa", "hiphophiphop"]))
