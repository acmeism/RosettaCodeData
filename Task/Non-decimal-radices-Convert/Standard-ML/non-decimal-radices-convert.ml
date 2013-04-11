fun toBase b v = let
  fun toBase' (a, 0) = a
    | toBase' (a, v) = toBase' (v mod b :: a, v div b)
in
  toBase' ([], v)
end

fun fromBase b ds =
  foldl (fn (k, n) => n * b + k) 0 ds

val toAlphaDigits = let
  fun convert n = if n < 10 then chr (n + ord #"0")
                            else chr (n + ord #"a" - 10)
in
  implode o map convert
end

val fromAlphaDigits = let
  fun convert c = if      Char.isDigit c then ord c - ord #"0"
                  else if Char.isUpper c then ord c - ord #"A" + 10
                  else if Char.isLower c then ord c - ord #"a" + 10
                  else raise Match
in
  map convert o explode
end
