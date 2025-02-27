import Data.List
import Data.Char

-- Defining all the grids I'll be using in one go.

rcBifid = [
  'A','B','C','D','E',
  'F','G','H','I','K',
  'L','M','N','O','P',
  'Q','R','S','T','U',
  'V','W','X','Y','Z'
  ] -- We will use strings here onwards. This was just a demonstration.

wikiBifid = "POLYBIUSCHERADFGKMNQTVWXZ"
cmiBifid = "CMIHASKELQWRTYUOPDFGZXVBN"

-- Convert a character to its grid coordinates (1-based index)
chr2pair square x = if x == 'J' then chr2pair square 'I' else case elemIndex x square of
  Nothing -> error "char is not in cipher grid"
  Just a -> (\(x,y) -> (x+1,y+1)) (divMod a 5) -- Convert flat index to (row, col)

pair2chr square (x,y) = square !! ((x-1)*5+y-1)

-- Pairs up elements from a list, used in Bifid encoding process
pairUp :: [a] -> [(a,a)]
pairUp [] = []
pairUp [a] = error "Odd number of elements"
pairUp (x:y:ys) = (x,y):(pairUp ys)

encrypt square message = map (pair2chr square) (pairUp (l ++ r)) where
  (l,r) = unzip $ map (chr2pair square) message

decrypt square message = map (pair2chr square) (zip u d) where
  (u,d) = splitAt (length message) $ concatMap (\(x,y) -> [x,y]) $ map (chr2pair square) message

main = do
  let
    message1 = "ATTACKATDAWN"
    message2 = "FLEEATONCE"
    encrypt1 = encrypt rcBifid message1
    encrypt2 = encrypt wikiBifid message2
    encrypt3 = encrypt wikiBifid message1
    myMessage = "The invasion will start on the first of January"
    encrypt4 = encrypt cmiBifid $ map toUpper $ filter (/= ' ') myMessage -- Remove spaces, uppercase

  putStrLn $ "Message 1: " ++ message1
  putStrLn $ "Encryption wrt RC's square: " ++ encrypt1
  putStrLn $ "Decrypt: " ++ show (decrypt rcBifid encrypt1)

  putStrLn $ "Message 2: " ++ message2
  putStrLn $ "Encryption wrt Wiki's square: " ++ encrypt2
  putStrLn $ "Decrypt: " ++ show (decrypt wikiBifid encrypt2)

  putStrLn $ "Message 3: " ++ message1
  putStrLn $ "Encryption wrt Wiki's square: " ++ encrypt3
  putStrLn $ "Decrypt: " ++ show (decrypt wikiBifid encrypt3)

  putStrLn $ "Message 4: " ++ myMessage
  putStrLn $ "Encryption wrt CMI square: " ++ encrypt4
  putStrLn $ "Decrypt: " ++ show (decrypt cmiBifid encrypt4)
