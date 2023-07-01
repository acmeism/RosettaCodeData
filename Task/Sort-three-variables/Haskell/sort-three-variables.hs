import Data.List (sort)

sortedTriple
  :: Ord a
  => (a, a, a) -> (a, a, a)
sortedTriple (x, y, z) =
  let [a, b, c] = sort [x, y, z]
  in (a, b, c)

sortedListfromTriple
  :: Ord a
  => (a, a, a) -> [a]
sortedListfromTriple (x, y, z) = sort [x, y, z]

-- TEST ----------------------------------------------------------------------
main :: IO ()
main = do
  print $
    sortedTriple
      ("lions, tigers, and", "bears, oh my!", "(from the \"Wizard of OZ\")")
  print $
    sortedListfromTriple
      ("lions, tigers, and", "bears, oh my!", "(from the \"Wizard of OZ\")")
  print $ sortedTriple (77444, -12, 0)
  print $ sortedListfromTriple (77444, -12, 0)
