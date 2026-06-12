import Text.Printf (printf)

onesPlusThree :: [Integer]
onesPlusThree =
  (3 +) . (10 *)
    <$> iterate (succ . (10 *)) 0

format :: Integer -> String
format = printf "%8lu^2 = %15lu" <*> (^ 2)

main :: IO ()
main =
  (putStr . unlines . take 8) $
    format <$> onesPlusThree
