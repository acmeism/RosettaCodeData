def to_roman_numeral:
  def romans:
      [100000, "\u2188"],
      [90000,  "ↂ\u2188"],
      [50000,  "\u2187"],
      [40000,  "ↂ\u2187"],
      [10000,  "ↂ"],
      [9000,  "Mↂ"],
      [5000,   "ↁ"],
      [4000,  "Mↁ"],
      [1000,   "M"],
      [900,   "CM"],
      [500,    "D"],
      [400,   "CD"],
      [100,    "C"],
      [90,    "XC"],
      [50,     "L"],
      [40,    "XL"],
      [10,     "X"],
      [9,     "IX"],
      [5,      "V"],
      [4,     "IV"],
      [1,      "I"] ;

  if . < 1 or . > 399999
  then "to_roman_numeral: \(.) is out of range" | error
  else reduce romans as [$i, $r] ({n: .};
        until (.n < $i;
          .res += $r
          | .n = .n - $i ) )
  | .res
  end ;
