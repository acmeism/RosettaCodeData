import Control.Monad (liftM)

isSorted wws@(_ : ws) = and $ zipWith (<=) wws ws

getLines = liftM lines . readFile

main = do
    ls <- getLines "unixdict.txt"
    let ow = filter isSorted ls
    let maxl = foldr max 0 (map length ow)
    print $ filter (\w -> (length w) == maxl) ow
