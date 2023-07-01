*Main> toAlphaDigits $ toBase 16 $ 42
"2a"
*Main> fromBase 16 $ fromAlphaDigits $ "2a"
42
