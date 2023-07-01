import Data.Bifunctor (bimap)
import Data.List (find)
import Data.Maybe (isJust)

-- MINIMUM POSITIVE MULTIPLE IN BASE 10 USING ONLY 0 AND 1

b10 :: Integral a => a -> Integer
b10 n = read (digitMatch rems sums) :: Integer
  where
    (_, rems, _, Just (_, sums)) =
      until
        (\(_, _, _, mb) -> isJust mb)
        ( \(e, rems, ms, _) ->
            let m = rem (10 ^ e) n
                newSums =
                  (m, [m]) :
                  fmap (bimap (m +) (m :)) ms
             in ( succ e,
                  m : rems,
                  ms <> newSums,
                  find
                    ( (0 ==) . flip rem n . fst
                    )
                    newSums
                )
        )
        (0, [], [], Nothing)

digitMatch :: Eq a => [a] -> [a] -> String
digitMatch [] _ = []
digitMatch xs [] = '0' <$ xs
digitMatch (x : xs) yys@(y : ys)
  | x /= y = '0' : digitMatch xs yys
  | otherwise = '1' : digitMatch xs ys

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    ( putStrLn
        . ( \x ->
              let b = b10 x
               in justifyRight 5 ' ' (show x)
                    <> " * "
                    <> justifyLeft 25 ' ' (show $ div b x)
                    <> " -> "
                    <> show b
          )
    )
    ( [1 .. 10]
        <> [95 .. 105]
        <> [297, 576, 594, 891, 909, 999]
    )

justifyLeft, justifyRight :: Int -> a -> [a] -> [a]
justifyLeft n c s = take n (s <> replicate n c)
justifyRight n c = (drop . length) <*> (replicate n c <>)
