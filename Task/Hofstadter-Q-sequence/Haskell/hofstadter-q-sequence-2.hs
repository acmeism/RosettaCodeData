douglasHofstadter :: Int -> [Int]
douglasHofstadter m = reverse (dSeqEffect [1,1] 2 m)
                      where
                           dSeqEffect xs n m | n > m = xs
                                             | otherwise = dSeqEffect (((xs !! (xs !! (n - 1))) + (xs !! (n - (xs !! (n - 1)))) ) : xs) (n + 1) m

-- main
getIntArg :: IO Int
getIntArg = fmap (read . head) getArgs

main = do
        args <- getIntArg
        print (douglasHofstadter args)
