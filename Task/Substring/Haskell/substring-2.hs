import qualified Data.Text as T
       (Text, take, drop, init, breakOn, pack, unpack)

fromNforM :: Int -> Int -> T.Text -> T.Text
fromNforM n m s = T.take m (T.drop n s)

fromNtoEnd :: Int -> T.Text -> T.Text
fromNtoEnd = T.drop

allButLast :: T.Text -> T.Text
allButLast = T.init

fromCharForM :: T.Text -> Int -> T.Text -> T.Text
fromCharForM needle m haystack = T.take m $ snd (T.breakOn needle haystack)

fromStringForM :: T.Text -> Int -> T.Text -> T.Text
fromStringForM = fromCharForM

-- TEST -----------------------------------------------------------------------
main :: IO ()
main =
  mapM_
    (putStrLn . T.unpack)
    ([ fromNforM 9 10
     , fromNtoEnd 20
     , allButLast
     , fromCharForM (T.pack "话") 6
     , fromStringForM (T.pack "大势") 6
     ] <*>
     [T.pack "天地不仁仁者人也🐒话说天下大势分久必合🍑合久必分🔥"])
