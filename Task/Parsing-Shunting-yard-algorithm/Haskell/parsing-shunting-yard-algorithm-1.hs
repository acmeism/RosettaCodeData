import Text.Printf

prec :: String -> Int
prec "^" = 4
prec "*" = 3
prec "/" = 3
prec "+" = 2
prec "-" = 2

leftAssoc :: String -> Bool
leftAssoc "^" = False
leftAssoc _ = True

isOp :: String -> Bool
isOp [t] = t `elem` "-+/*^"
isOp _ = False

simSYA :: [String] -> [([String], [String], String)]
simSYA xs = final <> [lastStep]
  where
    final = scanl f ([], [], "") xs
    lastStep =
      ( \(x, y, _) ->
          (reverse y <> x, [], "")
      )
        $ last final
    f (out, st, _) t
      | isOp t =
        ( reverse (takeWhile testOp st) <> out,
          (t :) (dropWhile testOp st),
          t
        )
      | t == "(" = (out, "(" : st, t)
      | t == ")" =
        ( reverse (takeWhile (/= "(") st) <> out,
          tail $ dropWhile (/= "(") st,
          t
        )
      | otherwise = (t : out, st, t)
      where
        testOp x =
          isOp x
            && ( leftAssoc t && prec t == prec x
                   || prec t < prec x
               )

main :: IO ()
main = do
  a <- getLine
  printf "%30s%20s%7s" "Output" "Stack" "Token"
  mapM_
    ( \(x, y, z) ->
        printf
          "%30s%20s%7s\n"
          (unwords $ reverse x)
          (unwords y)
          z
    )
    $ simSYA $ words a
