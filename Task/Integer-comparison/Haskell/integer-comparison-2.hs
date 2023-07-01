myCompare a b = case compare a b of
                  LT -> "A is less than B"
                  GT -> "A is greater than B"
                  EQ -> "A equals B"
