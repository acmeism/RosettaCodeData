calcRPN :: String -> [Double]
calcRPN = foldl interprete [] . words

interprete s x
  | x `elem` ["+","-","*","/","^"] = operate x s
  | otherwise = read x:s
  where
    operate op (x:y:s) = case op of
      "+" -> x + y:s
      "-" -> y - x:s
      "*" -> x * y:s
      "/" -> y / x:s
      "^" -> y ** x:s
