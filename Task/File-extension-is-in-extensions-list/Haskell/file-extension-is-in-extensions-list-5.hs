import Data.Char (toLower)
import Data.List (find, isSuffixOf)
import Data.Maybe (fromMaybe)

----------- FILE EXTENSION IS IN EXTENSIONS LIST ---------

extensionFound :: [String] -> String -> Maybe String
extensionFound xs fp = find (`isSuffixOf` fp) $ ('.' :) <$> xs


-------------------------- TESTS -------------------------
main :: IO ()
main =
  putStrLn $
  fTable
    "Any matching extensions found:\n"
    id
    (fromMaybe "n/a")
    (extensionFound
       (lowerCased ["zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2"]))
    (lowerCased
       [ "MyData.a##"
       , "MyData.tar.Gz"
       , "MyData.gzip"
       , "MyData.7z.backup"
       , "MyData..."
       , "MyData"
       , "MyData_v1.0.tar.bz2"
       , "MyData_v1.0.bz2"
       ])

------------------------- STRINGS ------------------------
fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  unlines $
  s : fmap (((<>) . rjust w ' ' . xShow) <*> ((" -> " <>) . fxShow . f)) xs
  where
    rjust n c = drop . length <*> (replicate n c <>)
    w = maximum (length . xShow <$> xs)

lowerCased :: [String] -> [String]
lowerCased = fmap (fmap toLower)
