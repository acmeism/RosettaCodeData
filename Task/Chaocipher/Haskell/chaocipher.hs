import Data.List (elemIndex)

chao :: Eq a => [a] -> [a] -> Bool -> [a] -> [a]
chao _ _ _ [] = []
chao l r plain (x : xs) = maybe [] go (elemIndex x src)
  where
    (src, dst)
      | plain = (l, r)
      | otherwise = (r, l)
    go n =
      dst !! n :
      chao
        (shifted 1 14 (rotated n l))
        ((shifted 2 14 . shifted 0 26) (rotated n r))
        plain
        xs

rotated :: Int -> [a] -> [a]
rotated n = take . length <*> drop n . cycle

shifted :: Int -> Int -> [a] -> [a]
shifted src dst s = concat [x, rotated 1 y, b]
  where
    (a, b) = splitAt dst s
    (x, y) = splitAt src a

encode, decode :: Bool
encode = False
decode = True

main :: IO ()
main = do
  let chaoWheels =
        chao
          "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
          "PTLNBQDEOYSFAVZKGJRIHWXUMC"
      plainText = "WELLDONEISBETTERTHANWELLSAID"
      cipherText = chaoWheels encode plainText
  mapM_
    print
    [ plainText,
      cipherText,
      chaoWheels decode cipherText
    ]
