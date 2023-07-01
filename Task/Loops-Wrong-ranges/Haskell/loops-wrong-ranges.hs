import Data.List

main = putStrLn $ showTable True '|' '-' '+' table

table = [["start","stop","increment","Comment","Code","Result/Analysis"]
        ,["-2","2","1","Normal","[-2,-1..2] or [-2..2]",show [-2,-1..2]]
        ,["-2","2","0","Zero increment","[-2,-2..2]","Infinite loop of -2 <=> repeat -2"]
        ,["-2","2","-1","Increments away from stop value","[-2,-3..2]",show [-2,-3..2]]
        ,["-2","2","10","First increment is beyond stop value","[-2,8..2]",show [-2,8..2]]
        ,["2","-2","1","Start more than stop: positive increment","[2,3.. -2]",show [2,3.. -2]]
        ,["2","2","1","Start equal stop: positive increment","[2,3..2]",show [2,3..2]]
        ,["2","2","-1","Start equal stop: negative increment","[2,1..2]",show [2,1..2]]
        ,["2","2","0","Start equal stop: zero increment","[2,2..2]","Infinite loop of 2 <=> repeat 2"]
        ,["0","0","0","Start equal stop equal zero: zero increment","[0,0..0]", "Infinite loop of 0 <=> repeat 0"]]

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
