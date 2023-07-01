import Data.List (find, isPrefixOf)
import Data.Char (isDigit, toUpper)
import Data.Maybe (maybe)

withExpansions :: [(String, Int)] -> String -> String
withExpansions tbl s = unwords $ expanded tbl <$> words s

expanded :: [(String, Int)] -> String -> String
expanded tbl k = maybe "*error" fst (expand k)
  where
    expand [] = Just ([], 0)
    expand s =
      let u = toUpper <$> s
          lng = length s
      in find (\(w, n) -> lng >= n && isPrefixOf u w) tbl

cmdsFromString :: String -> [(String, Int)]
cmdsFromString s =
  let go w@(x:_) (xs, n)
        | isDigit x = (xs, read w :: Int)
        | otherwise = ((toUpper <$> w, n) : xs, 0)
  in fst $ foldr go ([], 0) (words s)

-- TESTS --------------------------------------------------
table :: [(String, Int)]
table =
  cmdsFromString
    "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1 \
    \Schange Cinsert 2  Clast 3 compress 4 copy 2 count 3 Coverlay 3 \
    \cursor 3  delete 3 Cdelete 2  down 1  duplicate 3 xEdit 1 expand 3 \
    \extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 \
    \forward 2  get  help 1 hexType 4 input 1 powerInput 3  join 1 \
    \split 2 spltJOIN load locate 1 Clocate 2 lowerCase 3 upperCase 3 \
    \Lprefix 2  macro  merge 2 modify 3 move 2 msg  next 1 overlay 1 \
    \parse preserve 4 purge 3 put putD query 1 quit read recover 3 \
    \refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 \
    \rgtLEFT right 2 left 2  save  set  shift 2  si  sort  sos stack 3 \
    \status 4 top  transfer 3  type 1  up 1"

main :: IO ()
main = do
  let unAbbrev = withExpansions table
  print $
    unAbbrev
      "riG   rePEAT copies  put mo   rest    types   fup.    6      poweRin"
  print $ unAbbrev ""
