import qualified Data.Text as T
import Data.List

main = do
    putStrLn $ showTable True ' ' '-' ' ' $ ["p","isPrime"]:map (\p -> [show p, show $ isPrime p]) numbers
    putStrLn $ "The first 120 prime numbers are:"
    putStrLn $ see 20 $ take 120 primes
    putStrLn "The 1,000th to 1,015th prime numbers are:"
    putStrLn $ see 16.take 16 $ drop 999 primes


numbers = [2,3,9,15,29,37,47,57,67,77,87,97,237,409,659]

primes = [p | p <- 2:[3,5..], isPrime p]

isPrime :: Integer -> Bool
isPrime p = if p < 2 then False else 0 == mod (succ $ product [1..pred p]) p

bagOf :: Int -> [a] -> [[a]]
bagOf _ [] = []
bagOf n xs = let (us,vs) = splitAt n xs in us : bagOf n vs

see :: Show a => Int -> [a] -> String
see n = unlines.map unwords.bagOf n.map (T.unpack.T.justifyRight 3 ' '.T.pack.show)

showTable::Bool -> Char -> Char -> Char -> [[String]] -> String
showTable _ _ _ _ [] = []
showTable header ver hor sep contents = unlines $ hr:(if header then z:hr:zs else intersperse hr zss) ++ [hr]
   where
   vss = map (map length) $ contents
   ms = map maximum $ transpose vss ::[Int]
   hr = concatMap (\ n -> sep : replicate n hor) ms ++ [sep]
   top = replicate (length hr) hor
   bss = map (\ps -> map (flip replicate ' ') $ zipWith (-) ms ps) $ vss
   zss@(z:zs) = zipWith (\us bs -> (concat $ zipWith (\x y -> (ver:x) ++ y) us bs) ++ [ver]) contents bss
