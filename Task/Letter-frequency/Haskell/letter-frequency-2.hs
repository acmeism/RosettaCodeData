import qualified Data.Map as M

main = do
    text <- readFile "freq.hs"
    let result = foldl (flip (M.adjust (+1))) initial text
    mapM_ print $ M.toList result

initial = M.fromList $ zipWith (\k v -> (toEnum k,v)) [0..255] (repeat 0)
