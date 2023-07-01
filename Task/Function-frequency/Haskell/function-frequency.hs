import Language.Haskell.Parser (parseModule)
import Data.List.Split (splitOn)
import Data.List (nub, sortOn, elemIndices)

findApps src = freq $ concat [apps, comps]
  where
    ast = show $ parseModule src
    apps = extract <$> splitApp ast
    comps = extract <$> concat (splitComp <$> splitInfix ast)
    splitApp = tail . splitOn "(HsApp (HsVar (UnQual (HsIdent \""
    splitInfix = tail . splitOn "(HsInfixApp (HsVar (UnQual (HsIdent \""
    splitComp = take 1 . splitOn "(HsQVarOp (UnQual (HsSymbol \""
    extract = takeWhile (/= '\"')
    freq lst = [ (count x lst, x) | x <- nub lst ]
    count x = length . elemIndices x

main = do
  src <- readFile "CountFunctions.hs"
  let res = sortOn (negate . fst) $ findApps src
  mapM_ (\(n, f) -> putStrLn $ show n ++ "\t" ++ f) res
