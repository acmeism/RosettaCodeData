import Data.Set (Set, fromList, member)

------------------------ MCNUGGETS -----------------------

mcNuggets :: Set Int
mcNuggets =
  let size = enumFromTo 0 . quot 100
   in fromList $
        size 6
          >>= \x ->
            size 9
              >>= \y ->
                size 20
                  >>= \z ->
                    [ v
                      | let v = sum [6 * x, 9 * y, 20 * z],
                        101 > v
                    ]

--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . go) $
    dropWhile (`member` mcNuggets) [100, 99 .. 1]
  where
    go (x : _) = show x
    go [] = "No unreachable quantities found ..."
