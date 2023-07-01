{-# LANGUAGE RecordWildCards #-}

data SorterArgs = SorterArgs { cmp :: String, col :: Int, rev :: Bool } deriving Show
defSortArgs = SorterArgs "lex" 0 False


sorter :: SorterArgs -> [[String]] -> [[String]]
sorter (SorterArgs{..}) = case cmp of
                            _ -> undefined

main = do
    sorter defSortArgs{cmp = "foo", col=1, rev=True} [[]]
    sorter defSortArgs{cmp = "foo"} [[]]
    sorter defSortArgs [[]]
    return ()
