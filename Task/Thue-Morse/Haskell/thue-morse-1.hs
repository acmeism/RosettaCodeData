thueMorsePxs :: [[Int]]
thueMorsePxs = iterate ((++) <*> map (1 -)) [0]

{-
    = Control.Monad.ap (++) (map (1-)) `iterate` [0]
    = iterate (\ xs -> (++) xs (map (1-) xs)) [0]
    = iterate (\ xs -> xs ++ map (1-) xs) [0]
-}
main :: IO ()
main = print $ thueMorsePxs !! 5
