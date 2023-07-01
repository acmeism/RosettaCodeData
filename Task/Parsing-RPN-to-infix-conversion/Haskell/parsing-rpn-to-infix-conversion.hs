import Debug.Trace

data Expression = Const String | Exp Expression String Expression

------------- INFIX EXPRESSION FROM RPN STRING -----------

infixFromRPN :: String -> Expression
infixFromRPN = head . foldl buildExp [] . words

buildExp :: [Expression] -> String -> [Expression]
buildExp stack x
  | (not . isOp) x =
    let v = Const x : stack
     in trace (show v) v
  | otherwise =
    let v = Exp l x r : rest
     in trace (show v) v
  where
    r : l : rest = stack
    isOp = (`elem` ["^", "*", "/", "+", "-"])


--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    ( \s ->
        putStr (s <> "\n-->\n")
          >> (print . infixFromRPN)
            s
          >> putStrLn []
    )
    [ "3 4 2 * 1 5 - 2 3 ^ ^ / +",
      "1 2 + 3 4 + ^ 5 6 + ^",
      "1 4 + 5 3 + 2 3 * * *",
      "1 2 * 3 4 * *",
      "1 2 + 3 4 + +"
    ]

---------------------- SHOW INSTANCE ---------------------
instance Show Expression where
  show (Const x) = x
  show exp@(Exp l op r) = left <> " " <> op <> " " <> right
    where
      left
        | leftNeedParen = "( " <> show l <> " )"
        | otherwise = show l
      right
        | rightNeedParen = "( " <> show r <> " )"
        | otherwise = show r
      leftNeedParen =
        (leftPrec < opPrec)
          || ((leftPrec == opPrec) && rightAssoc exp)
      rightNeedParen =
        (rightPrec < opPrec)
          || ((rightPrec == opPrec) && leftAssoc exp)
      leftPrec = precedence l
      rightPrec = precedence r
      opPrec = precedence exp

leftAssoc :: Expression -> Bool
leftAssoc (Const _) = False
leftAssoc (Exp _ op _) = op `notElem` ["^", "*", "+"]

rightAssoc :: Expression -> Bool
rightAssoc (Const _) = False
rightAssoc (Exp _ op _) = op == "^"

precedence :: Expression -> Int
precedence (Const _) = 5
precedence (Exp _ op _)
  | op == "^" = 4
  | op `elem` ["*", "/"] = 3
  | op `elem` ["+", "-"] = 2
  | otherwise = 0
