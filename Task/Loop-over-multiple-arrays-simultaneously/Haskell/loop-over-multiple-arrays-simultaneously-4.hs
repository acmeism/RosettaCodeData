import Control.Applicative
main = sequence $ getZipList $ (\x y z -> putStrLn [x, y, z]) <$> ZipList "abd" <*> ZipList "ABC" <*> ZipList "123"
