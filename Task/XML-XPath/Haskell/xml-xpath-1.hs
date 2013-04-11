import Data.List
import Control.Arrow
import Control.Monad

takeWhileIncl           :: (a -> Bool) -> [a] -> [a]
takeWhileIncl _ []      =  []
takeWhileIncl p (x:xs)
            | p x       =  x : takeWhileIncl p xs
            | otherwise =  [x]

getmultiLineItem n = takeWhileIncl(not.isInfixOf ("</" ++ n)). dropWhile(not.isInfixOf ('<': n))
getsingleLineItems n = map (takeWhile(/='<'). drop 1. dropWhile(/='>')). filter (isInfixOf ('<': n))

main = do
  xml <- readFile "./Rosetta/xmlpath.xml"
  let xmlText = lines xml

  putStrLn "\n== First item ==\n"
  mapM_ putStrLn $ head $ unfoldr (Just. liftM2 (id &&&) (\\) (getmultiLineItem "item")) xmlText

  putStrLn "\n== Prices ==\n"
  mapM_ putStrLn $ getsingleLineItems "price" xmlText

  putStrLn "\n== Names ==\n"
  print $ getsingleLineItems "name" xmlText
