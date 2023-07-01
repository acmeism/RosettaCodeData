import Data.List (sort)

task
  :: (Ord b, Show b)
  => [b] -> [b]
task = map snd . sort . map (show >>= (,))

main = print $ task [1 .. 13]
