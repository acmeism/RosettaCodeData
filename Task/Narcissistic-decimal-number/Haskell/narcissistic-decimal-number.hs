import System.IO

digits :: (Read a, Show a) => a -> [a]
digits n = map (read . (:[])) $ show n

isNarcissistic :: (Show a, Read a, Num a, Eq a) => a -> Bool
isNarcissistic n =
  let dig = digits n
      len = length dig
  in n == (sum $ map (^ len) $ dig)

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  putStrLn $ unwords $ map show $ take 25 $ filter isNarcissistic [(0 :: Int)..]
