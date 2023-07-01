(define encodeGlyphs
  ACC 0 _ -> ACC
  ACC N [Glyph Value | Rest] -> (encodeGlyphs (@s ACC Glyph) (- N Value) [Glyph Value | Rest]) where (>= N Value)
  ACC N [Glyph Value | Rest] -> (encodeGlyphs ACC N Rest)
)

(define encodeRoman
  N -> (encodeGlyphs "" N ["M" 1000 "CM" 900 "D" 500 "CD" 400 "C" 100 "XC" 90 "L" 50 "XL" 40 "X" 10 "IX" 9 "V" 5 "IV" 4 "I" 1])
)
