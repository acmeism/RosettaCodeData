example :: [String]
example =
  ["the", "that", "a"] >>=
  \w1 ->
     when True ["frog", "elephant", "thing"] >>=
     \w2 ->
        when (joins w1 w2) ["walked", "treaded", "grows"] >>=
        \w3 ->
           when (joins w2 w3) ["slowly", "quickly"] >>=
           \w4 -> when (joins w3 w4) [w1, w2, w3, w4]

joins :: String -> String -> Bool
joins left right = last left == head right

when :: Bool -> [a] -> [a]
when p xs =
  if p
    then xs
    else []

main :: IO ()
main = print $ unwords example
