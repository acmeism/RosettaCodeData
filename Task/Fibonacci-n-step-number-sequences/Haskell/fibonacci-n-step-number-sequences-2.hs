nFibs :: [Int] -> [Int]
nFibs [] = []
nFibs xs =
  let go ys@(z:zs) = z : go (zs ++ [sum ys])
  in go xs

fibInit :: Int -> [Int]
fibInit = (1 :) . fmap (2 ^) . enumFromTo 0 . subtract 2

-- TEST ---------------------------------------------------------------
main :: IO ()
main = do
  putStrLn $
    justifyLeft 12 ' ' "Lucas" ++ "-> " ++ show (take 15 (nFibs [2, 1]))
  (putStrLn . unlines)
    (zipWith
       (\s n ->
           justifyLeft 12 ' ' (s ++ "naccci") ++
           ("-> " ++ show (take 15 (nFibs (fibInit n)))))
       (words "fibo tribo tetra penta hexa hepta octo nona deca")
       [2 ..])

justifyLeft :: Int -> Char -> String -> String
justifyLeft n c s = take n (s ++ replicate n c)
