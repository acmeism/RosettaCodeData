import Control.Monad (join)

root :: Int -> Float
root = sqrt . fromIntegral

nonSqr :: Int -> Int
nonSqr = (+) <*> (round . root)

notSquare :: Int -> Bool
notSquare = (/=) <*> (join (*) . floor . root)

main :: IO ()
main =
  mapM_
    putStrLn
    [ "First 22 members of the series:"
    , unwords $ (show . nonSqr) <$> [1 .. 22]
    , ""
    , "All first 10E6 members non square:"
    , show $ all (== True) $ (notSquare . nonSqr) <$> [1 .. 1000000]
    ]
