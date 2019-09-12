joins :: String -> String -> Bool
joins left right = last left == head right

-- First desugaring (dropping the do notation)
-- in terms of the bind operator (>>=) for the list monad

exampleBind :: String
exampleBind =
  ["the", "that", "a"] >>=
  (\w1 ->
      ["frog", "elephant", "thing"] >>=
      \w2 ->
         ["walked", "treaded", "grows"] >>=
         \w3 ->
            ["slowly", "quickly"] >>=
            (\w4 ->
                if joins w1 w2
                  then (if joins w2 w3
                          then (if joins w3 w4
                                  then unwords [w1, w2, w3, w4]
                                  else [])
                          else [])
                  else []))

-- Second desugaring (still dropping the do notation)
-- in terms of the concatMap, which is >>= with its arguments flipped

exampleConcatMap :: String
exampleConcatMap =
  concatMap
    (\w1 ->
        concatMap
          (\w2 ->
              concatMap
                (\w3 ->
                    concatMap
                      (\w4 ->
                          if joins w1 w2
                            then (if joins w2 w3
                                    then (if joins w3 w4
                                            then unwords [w1, w2, w3, w4]
                                            else [])
                                    else [])
                            else [])
                      ["slowly", "quickly"])
                ["walked", "treaded", "grows"])
          ["frog", "elephant", "thing"])
    ["the", "that", "a"]

main :: IO ()
main = do
  print exampleBind
  print exampleConcatMap
