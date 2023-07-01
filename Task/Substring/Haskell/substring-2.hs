{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text as T (Text, take, drop, init, breakOn)
import qualified Data.Text.IO as O (putStrLn)

fromMforN :: Int -> Int -> T.Text -> T.Text
fromMforN n m s = T.take m (T.drop n s)

fromNtoEnd :: Int -> T.Text -> T.Text
fromNtoEnd = T.drop

allButLast :: T.Text -> T.Text
allButLast = T.init

fromCharForN, fromStringForN :: Int -> T.Text -> T.Text -> T.Text
fromCharForN m needle haystack = T.take m $ snd $ T.breakOn needle haystack

fromStringForN = fromCharForN

-- TEST ---------------------------------------------------
main :: IO ()
main =
  mapM_
    O.putStrLn
    ([ fromMforN 9 10
     , fromNtoEnd 20
     , allButLast
     , fromCharForN 6 "话"
     , fromStringForN 6 "大势"
     ] <*>
     ["天地不仁仁者人也🐒话说天下大势分久必合🍑合久必分🔥"])
