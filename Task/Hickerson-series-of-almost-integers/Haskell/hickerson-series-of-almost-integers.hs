import Data.Number.CReal -- from numbers

hickerson :: Int -> CReal
hickerson n = (fromIntegral $ product [1..n]) / (2 * (log 2 ^ (n + 1)))

checkHickerson :: Int -> String
checkHickerson n  =
   let h = hickerson n
       postDecimalPointDigit = dropWhile (/='.') (show h) !! 1
       almostIntegral = '0' == postDecimalPointDigit || '9' == postDecimalPointDigit
   in "h(" ++ show n ++ ") = " ++ showCReal 4 h ++ " which is" ++ (if almostIntegral then "" else " NOT") ++ " almost integral."

main :: IO ()
main = mapM_ putStrLn [checkHickerson n | n <- [1..18]]
