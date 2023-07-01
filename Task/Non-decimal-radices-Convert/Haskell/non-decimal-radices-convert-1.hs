Prelude> Numeric.showIntAtBase 16 Char.intToDigit 42 ""
"2a"
Prelude> fst $ head $ Numeric.readInt 16 Char.isHexDigit Char.digitToInt "2a"
42
