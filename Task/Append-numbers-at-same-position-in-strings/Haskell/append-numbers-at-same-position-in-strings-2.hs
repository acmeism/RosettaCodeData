import Control.Applicative

main :: IO ()
main =
  mapM_ putStrLn $
  getZipList $
    (\x y z -> [x, y, z] >>= show) <$>
     ZipList [1, 2, 3, 4, 5, 6, 7, 8, 9] <*>
     ZipList [10, 11, 12, 13, 14, 15, 16, 17, 18] <*>
     ZipList [19, 20, 21, 22, 23, 24, 25, 26, 27]
