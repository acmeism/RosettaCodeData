import Data.List (group, sort)

main :: IO ()
main = interact (show . fmap ((,) . head <*> length) . group . sort
