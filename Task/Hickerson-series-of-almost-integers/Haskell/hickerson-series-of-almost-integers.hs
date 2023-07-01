import Data.Number.CReal -- from numbers

import qualified Data.Number.CReal as C

hickerson :: Int -> C.CReal
hickerson n = (fromIntegral $ product [1..n]) / (2 * (log 2 ^ (n + 1)))

charAfter :: Char -> String -> Char
charAfter ch string = ( dropWhile (/= ch) string ) !! 1

isAlmostInteger :: C.CReal -> Bool
isAlmostInteger = (`elem` ['0', '9']) . charAfter '.' . show

checkHickerson :: Int -> String
checkHickerson n  = show $ (n, hickerson n, isAlmostInteger $ hickerson n)

main :: IO ()
main = mapM_ putStrLn $ map checkHickerson [1..18]
