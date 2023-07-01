import Control.Applicative (ZipList (ZipList, getZipList))

main :: IO ()
main =
  mapM_ putStrLn $
    getZipList
      ( (\x y z -> [x, y, z])
          <$> ZipList "abc"
            <*> ZipList "ABC"
            <*> ZipList "123"
      )
      <> getZipList
        ( (\w x y z -> [w, x, y, z])
            <$> ZipList "abcd"
              <*> ZipList "ABCD"
              <*> ZipList "1234"
              <*> ZipList "一二三四"
        )
