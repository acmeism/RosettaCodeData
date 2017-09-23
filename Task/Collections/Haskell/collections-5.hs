import Data.Array (Array, listArray, Ix, (!))

triples :: Array Int (Char, String, String)
triples =
  listArray (0, 11) $
  zip3
    "鼠牛虎兔龍蛇馬羊猴鸡狗豬" -- 生肖 shengxiao – symbolic animals
    (words "shǔ niú hǔ tù lóng shé mǎ yáng hóu jī gǒu zhū")
    (words "rat ox tiger rabbit dragon snake horse goat monkey rooster dog pig")

indexedItem
  :: Ix i
  => Array i (Char, String, String) -> i -> String
indexedItem a n =
  let (c, w, w1) = a ! n
  in c : unwords ["\t", w, w1]

main :: IO ()
main = (putStrLn . unlines) $ indexedItem triples <$> [2, 4, 6]
