import Data.Char

-- predicate for valid symbol
isSymbolic ch = isAlphaNum ch || ch `elem` "_'"

-- predicate for valid type construtor
isConId s = and [ not (null s)
                , isUpper (head s)
                , all isSymbolic (tail s) ]

-- predicate for valid identifier
isVarId s = and [ not (null s)
                , isLower (head s)
                , all isSymbolic (tail s)
                , not (isReserved s) ]

-- predicate for reserved words
isReserved s = elem s ["case", "class", "data", "default", "deriving", "do "
                      , "else", "foreign", "if", "import", "in", "infix "
                      , "infixl", "infixr", "instance", "let", "module "
                      , "newtype", "of", "then", "type", "where", "_"
