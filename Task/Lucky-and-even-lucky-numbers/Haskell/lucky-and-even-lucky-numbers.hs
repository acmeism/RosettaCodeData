import System.Environment
import Text.Regex.Posix

data Lucky = Lucky | EvenLucky

helpMessage :: IO ()
helpMessage = do
  putStrLn "                           what is displayed  (on a single line)"
  putStrLn "     argument(s)              (optional verbiage is encouraged)"
  putStrLn "======================|==================================================="
  putStrLn " j                    | Jth       lucky number                            "
  putStrLn " j  ,          lucky  | Jth       lucky number                            "
  putStrLn " j  ,      evenLucky  | Jth  even lucky number                            "
  putStrLn "                                                                          "
  putStrLn " j  k                 | Jth  through  Kth (inclusive)       lucky numbers "
  putStrLn " j  k          lucky  | Jth  through  Kth (inclusive)       lucky numbers "
  putStrLn " j  k      evenlucky  | Jth  through  Kth (inclusive)  even lucky numbers "
  putStrLn "                                                                          "
  putStrLn " j -k                 | all       lucky numbers in the range  j -> |k|    "
  putStrLn " j -k          lucky  | all       lucky numbers in the range  j -> |k|    "
  putStrLn " j -k      evenlucky  | all  even lucky numbers in the range  j -> |k|    "
  putStrLn "======================|==================================================="

oddNumbers :: [Int]
oddNumbers = filter odd [1..]

evenNumbers :: [Int]
evenNumbers = filter even [1..]

luckyNumbers :: [Int] -> [Int]
luckyNumbers xs =
  let i = 3 in
  sieve i xs
    where
      sieve i (ln:s:xs) =
        ln : sieve (i + 1) (s : [x | (n, x) <- zip [i..] xs, rem n s /= 0])

nth :: Int -> Lucky -> Int
nth j Lucky     = luckyNumbers oddNumbers !! (j-1)
nth j EvenLucky = luckyNumbers evenNumbers !! (j-1)

range :: Int -> Int -> Lucky -> [Int]
range x x2 Lucky     = drop (x-1) (take x2 (luckyNumbers oddNumbers))
range x x2 EvenLucky = drop (x-1) (take x2 (luckyNumbers evenNumbers))

interval :: Int -> Int -> Lucky -> [Int]
interval x x2 Lucky     = dropWhile (<x) (takeWhile (<=x2) (luckyNumbers oddNumbers))
interval x x2 EvenLucky = dropWhile (<x) (takeWhile (<=x2) (luckyNumbers evenNumbers))

lucky :: [String] -> Lucky
lucky xs =
  if "evenLucky" `elem` xs
   then EvenLucky
   else Lucky

readn :: String -> Int
readn s = read s :: Int

isInt :: String -> Bool
isInt s = not (null (s =~ "-?[0-9]{0,10}" :: String))

main :: IO ()
main = do
  args <- getArgs
  if head args == "--help" || null args
    then
      helpMessage
    else
      let l = lucky args in
      case map readn (filter isInt args) of
        [] -> do
          putStrLn "Invalid input, missing arguments"
          putStrLn "Type --help"
        [x] -> print (nth x l)
        [x, x2] -> if x2 > 0
          then print (range x x2 l)
          else print (interval x (-x2) l)
        _ -> do
          putStrLn "Invalid input, wrong number of arguments"
          putStrLn "Type --help"
