import Data.List (nub)

main :: IO ()
main =
  let xs = [1 .. 7]
  in mapM_ print $
     xs >>=
     \x ->
        xs >>=
        \y ->
           xs >>=
           \z ->
              [ (x, y, z)
              | even x && 3 == length (nub [x, y, z]) && 12 == sum [x, y, z] ]
