{-# LANGUAGE FlexibleContexts #-}
import Text.Parsec

toRPN = parse impl "expression" . filter (/= ' ')
  where
    impl = chainl1 disj (op2 "=>")
    disj = chainl1 conj (op2 "|"  <|>  op2 "^")
    conj = chainl1 term (op2 "&")
    term = string "(" *> impl <* string ")" <|>
           op1 "!" <*> term <|>
           many1 alphaNum
    op1 s = (\x -> unwords [x, s])      <$ string s
    op2 s = (\x y -> unwords [x, y, s]) <$ string s
