module ISINVerification2 where

import Data.Char (isUpper, isDigit, digitToInt)

verifyISIN :: String -> Bool
verifyISIN isin =
  correctFormat isin && mod (oddsum + multiplied_even_sum) 10 == 0
  where
    reverted = reverse $ convertToNumber isin
    theOdds = fst $ collectOddandEven reverted
    theEvens = snd $ collectOddandEven reverted
    oddsum = sum $ map digitToInt theOdds
    multiplied_even_sum = addUpDigits $ map ((* 2) . digitToInt) theEvens

capitalLetters :: String
capitalLetters = ['A','B' .. 'Z']

numbers :: String
numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

correctFormat :: String -> Bool
correctFormat isin =
  (length isin == 12) &&
  all (`elem` capitalLetters) (take 2 isin) &&
  all (\c -> elem c capitalLetters || elem c numbers) (drop 2 $ take 11 isin) &&
  elem (last isin) numbers

convertToNumber :: String -> String
convertToNumber = concatMap convert
  where
    convert :: Char -> String
    convert c =
      if isDigit c
        then show $ digitToInt c
        else show (fromEnum c - 55)

collectOddandEven :: String -> (String, String)
collectOddandEven term
  | odd $ length term =
    ( concat
        [ take 1 $ drop n term
        | n <- [0,2 .. length term - 1] ]
    , concat
        [ take 1 $ drop d term
        | d <- [1,3 .. length term - 2] ])
  | otherwise =
    ( concat
        [ take 1 $ drop n term
        | n <- [0,2 .. length term - 2] ]
    , concat
        [ take 1 $ drop d term
        | d <- [1,3 .. length term - 1] ])

addUpDigits :: [Int] -> Int
addUpDigits list =
  sum $
  map
    (\d ->
        if d > 9
          then sum $ map digitToInt $ show d
          else d)
    list

printSolution :: String -> IO ()
printSolution str = do
  putStr $ str ++ " is"
  if verifyISIN str
    then putStrLn " valid"
    else putStrLn " not valid"

main :: IO ()
main = do
  let isinnumbers =
        [ "US0378331005"
        , "US0373831005"
        , "U50378331005"
        , "US03378331005"
        , "AU0000XVGZA3"
        , "AU0000VXGZA3"
        , "FR0000988040"
        ]
  mapM_ printSolution isinnumbers
