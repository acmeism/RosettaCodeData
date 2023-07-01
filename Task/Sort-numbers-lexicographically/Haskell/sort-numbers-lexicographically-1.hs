import Data.List (sort)

task :: (Ord b, Show b) => [b] -> [b]
task = map snd . sort . map (\i -> (show i, i))

main = print $ task [1 .. 13]
