import Control.Monad (mapM, foldM, forever)
import Data.List (unwords, unlines, nub)
import Data.Maybe (fromJust)

truthTable expr = let
    tokens = words expr
    operators = ["&", "|", "!", "^", "=>"]
    variables = nub $ filter (not . (`elem` operators)) tokens
    table = zip variables <$> mapM (const [True,False]) variables
    results = map (\r -> (map snd r) ++ (calculate tokens) r) table
    header = variables ++ ["result"]
    in
      showTable $ header : map (map show) results

-- Performs evaluation of token sequence in a given context.
-- The context is an assoc-list, which binds variable and it's value.
-- Here the monad is simple ((->) r).
calculate :: [String] -> [(String, Bool)] -> [Bool]
calculate = foldM interprete []
  where
    interprete (x:y:s) "&"  = (: s) <$> pure (x && y)
    interprete (x:y:s) "|"  = (: s) <$> pure (x || y)
    interprete (x:y:s) "^"  = (: s) <$> pure (x /= y)
    interprete (x:y:s) "=>" = (: s) <$> pure (not y || x)
    interprete (x:s)   "!"  = (: s) <$> pure (not x)
    interprete s var        = (: s) <$> fromJust . lookup var

-- pretty printing
showTable tbl = unlines $ map (unwords . map align) tbl
  where
    align txt = take colWidth $ txt ++ repeat ' '
    colWidth = max 6 $ maximum $ map length (head tbl)

main = forever $ getLine >>= putStrLn . truthTable
