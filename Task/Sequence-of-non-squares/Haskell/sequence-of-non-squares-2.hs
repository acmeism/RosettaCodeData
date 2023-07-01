import Control.Monad (join)

----------------------- NON SQUARES ----------------------

notSquare :: Int -> Bool
notSquare = (/=) <*> (join (*) . floor . root)

nonSqr :: Int -> Int
nonSqr = (+) <*> (round . root)

root :: Int -> Float
root = sqrt . fromIntegral


-------------------------- TESTS -------------------------
main :: IO ()
main =
  mapM_
    putStrLn
    [ "First 22 members of the series:",
      unwords $ show . nonSqr <$> [1 .. 22],
      "",
      "All first 10E6 members non square:",
      (show . and) $
        notSquare . nonSqr <$> [1 .. 1000000]
    ]
