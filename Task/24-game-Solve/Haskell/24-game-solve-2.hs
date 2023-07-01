import Control.Applicative
import Data.List
import Text.PrettyPrint


data Expr = C Int | Op String Expr Expr

toDoc (C     x  ) = int x
toDoc (Op op x y) = parens $ toDoc x <+> text op <+> toDoc y

ops :: [(String, Int -> Int -> Int)]
ops = [("+",(+)), ("-",(-)), ("*",(*)), ("/",div)]


solve :: Int -> [Int] -> [Expr]
solve res = filter ((Just res ==) . eval) . genAst
  where
    genAst [x] = [C x]
    genAst xs  = do
      (ys,zs) <- split xs
      let f (Op op _ _) = op `notElem` ["+","*"] || ys <= zs
      filter f $ Op <$> map fst ops <*> genAst ys <*> genAst zs

    eval (C      x  ) = Just x
    eval (Op "/" _ y) | Just 0 <- eval y = Nothing
    eval (Op op  x y) = lookup op ops <*> eval x <*> eval y


select :: Int -> [Int] -> [[Int]]
select 0 _  = [[]]
select n xs = [x:zs | k <- [0..length xs - n]
                    , let (x:ys) = drop k xs
                    , zs <- select (n - 1) ys
                    ]

split :: [Int] -> [([Int],[Int])]
split xs = [(ys, xs \\ ys) | n <- [1..length xs - 1]
                           , ys <- nub . sort $ select n xs
                           ]


main = mapM_ (putStrLn . render . toDoc) $ solve 24 [2,3,8,9]
