import qualified Data.Set as S

------ DICTIONARY WORDS TWINNED BY e -> i REPLACEMENT ----

ieTwins :: String -> [(String, String)]
ieTwins s =
  [ (w, twin)
    | w <- filter ('e' `elem`) longWords,
      let twin = iForE w,
      S.member twin lexicon
  ]
  where
    longWords = filter ((5 <) . length) (lines s)
    lexicon = S.fromList $ filter ('i' `elem`) longWords

iForE :: String -> String
iForE [] = []
iForE ('e' : cs) = 'i' : iForE cs
iForE (c : cs) = c : iForE cs

--------------------------- TEST -------------------------
main :: IO ()
main =
  readFile "unixdict.txt"
    >>= (mapM_ print . ieTwins)
